/* read hdf5 and write data summary */

/* Time-stamp: <Monday, 02 May 2016, 15:58 MDT -- zgompert> */


/* Compilation for Linux */
/* h5cc -Wall -O3 -o estpost.entropy estpost_h5_entropy.c -lgsl -lgslcblas */
/* Compilation for OSX */
/* h5cc -Wall -O3 -o estpost.entropy estpost_h5_entropy.c -lgsl -lm */


#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <math.h>
#include <gsl/gsl_matrix.h>
#include <gsl/gsl_vector.h>
#include <gsl/gsl_statistics.h>
#include <gsl/gsl_sort.h>
#include <gsl/gsl_sort_vector.h>
#include <gsl/gsl_histogram.h>

#include "hdf5.h"
#include <getopt.h>

/* header, function declarations */
#define INDEXLOWERTRIPLUSDIAG (k * (k-1)) / 2 + n + k
#define VERSION "1.2 - 23 September 2013"
#define MAXFILEN 20 /* maximum number of infiles */
void usage(char * name);;

void estpost(hid_t * file, const char * param, double credint, int burn, int nbins, 
	     int sumtype, int wids, int nchains);

int paramexists(const char * param);

void calcindpop(const char * param, hid_t dataspace, hid_t * dataset, gsl_matrix * sample,
		gsl_vector * onesample,
		gsl_histogram * hist, double credint, int nind, int npop, int nsamples,  
		int burn, int nbins, int sumtype, int wids, int nchains);

void calcindpopltpd(const char * param, hid_t dataspace, hid_t * dataset, gsl_matrix * sample,
		    gsl_vector * onesample,
		    gsl_histogram * hist, double credint, int nind, int npop, int nsamples,  
		    int burn, int nbins, int sumtype, int wids, int nchains);

void calclocuspop(const char * param, hid_t dataspace, hid_t * dataset, gsl_matrix * sample,
		  gsl_vector * onesample, 
		  gsl_histogram * hist, double credint, int nloci, int npop, int nsamples,  
		  int burn, int nbins, int sumtype, int wids, int nchains);

void calcparam(const char * param, hid_t dataspace, hid_t * dataset, 
	       gsl_matrix * sample, gsl_vector * onesample, gsl_histogram * hist,
	       double credint, int nparam, int nsamples, int burn, 
	       int nbins, int sumtype, int wids, int nchains);

void calcsimple(const char * param, hid_t dataspace, hid_t * dataset, gsl_matrix * sample,
		gsl_vector * onesample, gsl_histogram * hist, double credint,
		int nsamples, int burn, int nbins, int sumtype, int wids, int nchains);

void calcci(gsl_vector * sample, double credint, int nsamples);

void calchist(gsl_vector * sample,  gsl_histogram * hist, int nsamples, int nbins);

void writetext(gsl_vector * sample,  int nsamples);

void calcdic(gsl_vector * sample, int nsamples);

void calcdiag(gsl_matrix * sample, gsl_vector * catsample, int nsamples, int nchains);

double calcess(gsl_matrix * sample, int nsamples, int nchains);

double calcpsrf(gsl_matrix * sample, gsl_vector * catsample, int nsamples, int nchains);

double lag_n_autocorrelation(double x[], double mu, int n, int N);

void writeLIG(const char * param, hid_t dataspace, hid_t * dataset, gsl_vector * sample,
	      int nloci, int nind, int ngeno, int wids, int nchains);

void  unwrapmatrix(gsl_matrix * m, gsl_vector * v, int d1, int d2);

FILE * outfp; 

/* beginning of main */

int main (int argc, char **argv) {
  int sumtype = 0; /* summary to perform
		      0 = estimate and ci, 1 = histogram, 2 = convert to text */
  int ch = 0;
  int burn = 0; /* discard the first burn samples as a burn-in */
  int nbins = 20; /* number of bins for histogram */
  int wids = 1; /* boolean, write ids in first column */
  int c;
  char * infile = "undefined"; /* filename */
  char * outfile = "postout.txt";
  char * param = "undefined"; /* parameter to summarize */

  int nchains = 0; /* number of mcmc chains = number of infiles */

  double credint = 0.95; /* default = 95% credible interval, this is ETPI */

  /* variables for getopt_long */
  static struct option long_options[] = {
    {"version", no_argument, 0, 'v'},
    {0, 0, 0, 0} 
  };
  int option_index = 0;

  /* variables for hdf5 */
  hid_t file[MAXFILEN];         /* file handle */
  
  /*  get command line arguments */
  if (argc < 2) {
    usage(argv[0]);
  }
  
  while ((ch = getopt_long(argc, argv, "o:v:p:c:b:h:s:w:", 
			   long_options, &option_index)) != -1){
    switch(ch){
    case 'o':
      outfile = optarg;
      break;
    case 'p':
      param = optarg;
      break;
    case 'c':
      credint = atof(optarg);
      break;
    case 'b':
      burn = atoi(optarg);
      break;
    case 'h':
      nbins = atoi(optarg);
      break;
    case 's':
      sumtype = atoi(optarg);
      break;
    case 'w':
      wids = atoi(optarg);
      break;
    case 'v':
      printf("%s version %s\n", argv[0], VERSION); 
      /* VERSION is a macro */
      exit(0); /* note program will exit if this option is specified */
    case '?':
    default:
      usage(argv[0]);
    }
  }

  if(!paramexists(param)){
    printf("The specified parameter does not exist in entropy or the estpost code is out-of-date\n");
    printf("The known parameters are: gprob, zprob, p, q, pi, fst, alpha, gamma, deviance\n");
    exit(1);
  }

  /* open the h5 files, read only */
  while (optind < argc){
    infile = argv[optind];
    printf("file = %s\n",infile);
    file[nchains] = H5Fopen(infile, H5F_ACC_RDONLY, H5P_DEFAULT);
    nchains++;
    optind++;
  }

 /* open the outfile */
  outfp = fopen(outfile, "w");
  if ( !outfp ){
    fprintf(stderr, "Can't open %s for writing!\n", outfile);
    exit(1);
  }
  if ((sumtype == 0) && (wids == 1) && (strcmp(param, "gprob") != 0)){
    fprintf(outfp,"param,mean,median,ci_%.3f_LB,ci_%.3f_UB\n", credint, credint);
  }
  else if ((sumtype == 4) && (wids == 1)){
    fprintf(outfp,"param,effectiveSampleSize,potentialScaleReductionFactor\n");
  }

  /* main function */
  estpost(file, param, credint, burn, nbins, sumtype, wids, nchains);
  
  fclose(outfp);
  for(c=0; c<nchains; c++){
    H5Fclose(file[c]);
  }
  return 0;
}

/* ---------------- Functions ------------------ */

/* Prints usage */
void usage(char * name){
  fprintf(stderr,"\n%s version %s\n\n", name, VERSION); 
  fprintf(stderr, "Usage:   estpost.entropy [options] infile1.hdf5 infile2.hdf5\n");
  fprintf(stderr, "-o     Outfile [default = postout.txt]\n");
  fprintf(stderr, "-p     Name of parameter to summarize, e.g., 'q'\n");
  fprintf(stderr, "-c     Credible interval to calculate [default = 0.95]\n");
  fprintf(stderr, "-b     Number of additinal MCMC samples to discard for burn-in [default = 0]\n");
  fprintf(stderr, "-h     Number of bins for posterior sample histogram [default = 20]\n");
  fprintf(stderr, "-s     Which summary to perform: 0 = posterior estimates and credible intervals\n");
  fprintf(stderr, "                                 1 = histogram of posterior samples\n");
  fprintf(stderr, "                                 2 = convert to plain text\n");
  fprintf(stderr, "                                 3 = calculate DIC\n");
  fprintf(stderr, "                                 4 = MCMC diagnostics\n");
  fprintf(stderr, "-w     Write parameter identification to file, boolean [default = 1]\n");
  fprintf(stderr, "-v     Display estpost.entropy software version\n");
  exit(1);
}

/* Function estimates the mean, median and credible interval of a
   continous posterior distribution, simply writes discrete
   posterior distribution, or write text for parameter to file */
void estpost(hid_t * file, const char * param, double credint, int burn, int nbins, 
	     int sumtype, int wids, int nchains){
  gsl_matrix * sample;
  gsl_vector * onesample;
  gsl_histogram * hist;
  hid_t dataset[MAXFILEN], dataspace;
  hsize_t dims[3]; /* note 3 dimensions is maximum in this application */
  int rank = 0, status_n = 0;
  /* dimensions for mcmc samples */
  int nloci = 0, nind = 0, npop = 0, nsamples = 0, ngeno = 0, nltpd = 0;
  int chain;

  hist = gsl_histogram_alloc((size_t) nbins);
  /* we already have checked that param should exist in input hdf5 file*/
  for (chain=0; chain<nchains; chain++){
    dataset[chain] = H5Dopen2(file[chain], param, H5P_DEFAULT);
  }
  dataspace = H5Dget_space(dataset[0]); // we assume that all chains have the same dimensions
  rank = H5Sget_simple_extent_ndims(dataspace); 
  status_n = H5Sget_simple_extent_dims(dataspace, dims, NULL);

  /* interpret dimensions based on parameter, then calculate (if
     necessary) and print desired quantities */

  if ((strcmp(param, "gprob") == 0)){ /* LIG */
    nloci = dims[0];
    nind = dims[1];
    ngeno = dims[2];
    printf("parameter dimensions for %s: loci = %d, ind = %d, genotypes = %d, chains = %d\n", 
	   param, nloci, nind, ngeno,nchains);
    onesample = gsl_vector_calloc(nloci);
    if (sumtype == 0)
      writeLIG(param, dataspace, dataset, onesample, nloci, nind, ngeno, wids, nchains);
    else{ 
      fprintf(stderr, "Only summary type 0 is available for genotypes\n");
      exit(1);
    }
  }
  else if ((strcmp(param, "zprob") == 0)){ /* LIA */
    /* no calculation needed, data object is full posterior, just need to grab correct data */
    nloci = dims[0];
    nind = dims[1];
    npop = dims[2];
    printf("parameter dimensions for %s: loci = %d, ind = %d, pops = %d\n", 
	   param, nloci, nind, npop);
    printf("sorry... but nothing is done for this parameter; use a different model and program if you are really interested in local ancestry\n");
    /* writeLIA(param, dataspace, dataset, nloci, nind, npop, wids);  */
  }
  else if (strcmp(param, "p") == 0){ /* LPM */
    nloci = dims[0];
    npop = dims[1];
    nsamples = dims[2];
    if (burn >= nsamples){
      printf("Burnin exceeds number of samples\n");
      exit(1);
    }
    sample = gsl_matrix_calloc(nsamples - burn, nchains);
    onesample = gsl_vector_calloc(nsamples - burn);
    printf("parameter dimensions for %s: loci = %d, populations = %d, samples = %d, chains = %d\n", 
	   param, nloci, npop, nsamples, nchains);
    calclocuspop(param, dataspace, dataset, sample, onesample, hist, credint, 
		 nloci, npop, nsamples, burn, nbins, sumtype, wids, nchains); 
  }
  else if (strcmp(param, "q") == 0){  /* IPM */
    nind = dims[0];
    npop = dims[1];
    nsamples = dims[2];
    if (burn >= nsamples){
      printf("Burnin exceeds number of samples\n");
      exit(1);
    }
    sample = gsl_matrix_calloc(nsamples - burn, nchains);
    onesample = gsl_vector_calloc(nsamples - burn);
    printf("parameter dimensions for %s: ind = %d, populations = %d, samples = %d, chains = %d\n", 
	   param, nind, npop, nsamples, nchains);
    calcindpop(param, dataspace, dataset, sample, onesample, hist, credint,  
     	       nind, npop, nsamples, burn, nbins, sumtype, wids, nchains); 

  }
  else if (strcmp(param, "Q") == 0){  /* IQM */
    nind = dims[0];
    nltpd = dims[1];
    npop = (int) (-1 + sqrt(1+8*nltpd))/2; /* whoot, quadratic equation */
    nsamples = dims[2];
    if (burn >= nsamples){
      printf("Burnin exceeds number of samples\n");
      exit(1);
    }
    sample = gsl_matrix_calloc(nsamples - burn, nchains);
    onesample = gsl_vector_calloc(nsamples - burn);
    printf("parameter dimensions for %s: ind = %d, populations = %d, samples = %d, chains = %d\n", 
	   param, nind, npop, nsamples, nchains);
    calcindpopltpd(param, dataspace, dataset, sample, onesample, hist, credint,  
		   nind, npop, nsamples, burn, nbins, sumtype, wids, nchains); 

  }


  else if (strcmp(param, "pi") == 0){  /* LM */
    nloci = dims[0];
    nsamples = dims[1];
    if (burn >= nsamples){
      printf("Burnin exceeds number of samples\n");
      exit(1);
    }
    sample = gsl_matrix_calloc(nsamples - burn, nchains);
    onesample = gsl_vector_calloc(nsamples - burn);
    printf("parameter dimensions for %s: loci = %d, samples = %d, chains = %d\n", 
	   param, npop, nsamples, nchains);
    calcparam(param, dataspace, dataset, sample, onesample, hist, credint, 
	      nloci, nsamples, burn, nbins, sumtype, wids, nchains);
  }
  else if (strcmp(param, "fst") == 0){  /* PM */
    npop = dims[0];
    nsamples = dims[1];
    if (burn >= nsamples){
      printf("Burnin exceeds number of samples\n");
      exit(1);
    }
    sample = gsl_matrix_calloc(nsamples - burn, nchains);
    onesample = gsl_vector_calloc(nsamples - burn);
    printf("parameter dimensions for %s: populations = %d, samples = %d, chains = %d\n", 
	   param, npop, nsamples, nchains);
    calcparam(param, dataspace, dataset, sample, onesample, hist, credint, 
	      npop, nsamples, burn, nbins, sumtype, wids, nchains); 
  }
  else if (strcmp(param, "alpha") == 0  || 
	   strcmp(param, "gamma") == 0  ||
	   strcmp(param, "deviance") == 0 ){ 
    nsamples = dims[0];
    if (burn >= nsamples){
      printf("Burnin exceeds number of samples\n");
      exit(1);
    }
    sample = gsl_matrix_calloc(nsamples - burn, nchains);
    onesample = gsl_vector_calloc(nsamples - burn);
    printf("parameter dimensions for %s: samples = %d, chains = %d\n", param, nsamples, nchains);
    calcsimple(param, dataspace, dataset, sample, onesample, hist, credint, 
		 nsamples, burn, nbins, sumtype, wids, nchains); 
  }
  else {
    printf("Error in finding parameter.  Should not be possible.\n");
    exit(1);
  }
}


/* calculate summaries for parameters indexed by ind and
   population */
void calcindpop(const char * param, hid_t dataspace, hid_t * dataset, gsl_matrix * sample,
		gsl_vector * onesample,
		gsl_histogram * hist, double credint, int nind, int npop, int nsamples,  
		int burn, int nbins, int sumtype, int wids, int nchains){
  int i, j, c;
  hid_t mvector;
  hsize_t start[3];  /* Start of hyperslab */
  hsize_t count[3] = {1,1,1};  /* Block count */
  hsize_t block[3] = {1, 1, nsamples - burn};

  herr_t ret;
  hsize_t samdim[1];

  gsl_vector * catsample;
  catsample = gsl_vector_calloc(nchains * (nsamples - burn));

  /* create vector for buffer */
  samdim[0] = nsamples - burn;
  mvector = H5Screate_simple(1, samdim, NULL);

  start[2] = burn;
  /* loop through population, then locus */
  for (j=0; j<npop; j++){
    for (i=0; i<nind; i++){
      if (wids == 1){
	fprintf(outfp,"%s_ind_%d_pop_%d,",param,i,j);
      }
      start[0] = i; start[1] = j; /* start[2] = burn; */
      for (c=0; c<nchains; c++){
	ret = H5Sselect_hyperslab(dataspace, H5S_SELECT_SET, start, NULL, count, block);
	ret = H5Dread(dataset[c], H5T_NATIVE_DOUBLE, mvector, dataspace, H5P_DEFAULT, 
		      onesample->data);
	gsl_matrix_set_col(sample, c, onesample);
      }
      unwrapmatrix(sample, catsample, (nsamples - burn), nchains);
      /* estimate and credible intervals */
      if (sumtype == 0){
	calcci(catsample, credint, (nsamples - burn) * nchains);
      }
      /* generate histogram */
      else if (sumtype == 1){
	calchist(catsample, hist, (nsamples - burn) * nchains, nbins);
      }
      /* write to text file */
      else if (sumtype == 2){
	writetext(catsample, (nsamples - burn) * nchains);
      }
      /* write diagnostics */
      else if (sumtype == 4){
	calcdiag(sample, catsample, (nsamples - burn), nchains);
      }
    }
  } 
  H5Sclose(mvector);
}

/* calculate summaries for parameters indexed by ind and the lower
   triangle/plus diagonal of the population x population matrix of
   ancestry */
void calcindpopltpd(const char * param, hid_t dataspace, hid_t * dataset, gsl_matrix * sample,
		    gsl_vector * onesample,
		    gsl_histogram * hist, double credint, int nind, int npop, int nsamples,  
		    int burn, int nbins, int sumtype, int wids, int nchains){
  int i, k, n, c;
  hid_t mvector;
  hsize_t start[3];  /* Start of hyperslab */
  hsize_t count[3] = {1,1,1};  /* Block count */
  hsize_t block[3] = {1, 1, nsamples - burn};

  herr_t ret;
  hsize_t samdim[1];

  gsl_vector * catsample;
  catsample = gsl_vector_calloc(nchains * (nsamples - burn));

  /* create vector for buffer */
  samdim[0] = nsamples - burn;
  mvector = H5Screate_simple(1, samdim, NULL);

  start[2] = burn;
  /* loop through population, then locus */
  for (k=0; k<npop; k++){
    for(n=0; n<=k; n++){
      for (i=0; i<nind; i++){
	if (wids == 1){
	  fprintf(outfp,"%s_ind_%d_anc_%d-%d,",param,i,k,n);
	}
	start[0] = i; start[1] = INDEXLOWERTRIPLUSDIAG; /* start[2] = burn; */
	for (c=0; c<nchains; c++){
	  ret = H5Sselect_hyperslab(dataspace, H5S_SELECT_SET, start, NULL, count, block);
	  ret = H5Dread(dataset[c], H5T_NATIVE_DOUBLE, mvector, dataspace, H5P_DEFAULT, 
			onesample->data);
	  gsl_matrix_set_col(sample, c, onesample);
	}
	unwrapmatrix(sample, catsample, (nsamples - burn), nchains);
	/* estimate and credible intervals */
	if (sumtype == 0){
	  calcci(catsample, credint, (nsamples - burn) * nchains);
	}
	/* generate histogram */
	else if (sumtype == 1){
	  calchist(catsample, hist, (nsamples - burn) * nchains, nbins);
	}
	/* write to text file */
	else if (sumtype == 2){
	  writetext(catsample, (nsamples - burn) * nchains);
	}
	/* write diagnostics */
	else if (sumtype == 4){
	  calcdiag(sample, catsample, (nsamples - burn), nchains);
	}
      }
    } 
  }
  H5Sclose(mvector);
}


/* calculate summaries for parameters indexed by locus and
   population */
void calclocuspop(const char * param, hid_t dataspace, hid_t * dataset, gsl_matrix * sample,
		  gsl_vector * onesample, 
		  gsl_histogram * hist, double credint, int nloci, int npop, int nsamples,  
		  int burn, int nbins, int sumtype, int wids, int nchains){
  int i, j, c;
  hid_t mvector;
  hsize_t start[3];  /* Start of hyperslab */
  hsize_t count[3] = {1,1,1};  /* Block count */
  hsize_t block[3] = {1, 1, nsamples - burn};

  herr_t ret;
  hsize_t samdim[1];

  gsl_vector * catsample;
  catsample = gsl_vector_calloc(nchains * (nsamples - burn));

  /* create vector for buffer */
  samdim[0] = nsamples - burn;
  mvector = H5Screate_simple(1, samdim, NULL);

  start[2] = burn;
  /* loop through population, then locus */
  for (j=0; j<npop; j++){
    for (i=0; i<nloci; i++){
      if (wids == 1){
	fprintf(outfp,"%s_loc_%d_pop_%d,",param,i,j);
      }
      start[0] = i; start[1] = j; /* start[2] = burn; */
      for (c=0; c<nchains; c++){
	ret = H5Sselect_hyperslab(dataspace, H5S_SELECT_SET, start, NULL, count, block);
	ret = H5Dread(dataset[c], H5T_NATIVE_DOUBLE, mvector, dataspace, H5P_DEFAULT, 
		      onesample->data);
	gsl_matrix_set_col(sample, c, onesample);
      }
      unwrapmatrix(sample, catsample, (nsamples - burn), nchains);
      /* estimate and credible intervals */
      if (sumtype == 0){
	calcci(catsample, credint, (nsamples - burn) * nchains);
      }
      /* generate histogram */
      else if (sumtype == 1){
	calchist(catsample, hist, (nsamples - burn) * nchains, nbins);
      }
      /* write to text file */
      else if (sumtype == 2){
	writetext(catsample, (nsamples - burn)  * nchains);
      }
      /* write diagnostics */
      else if (sumtype == 4){
	calcdiag(sample, catsample, (nsamples - burn), nchains);
      }
    }
  } 
  H5Sclose(mvector);
}

/* calculate summaries for parameters indexed by population PM or
   locus LM (e.g., fst and pi) */
void calcparam(const char * param, hid_t dataspace, hid_t * dataset, 
	       gsl_matrix * sample, gsl_vector * onesample, gsl_histogram * hist,
	       double credint, int nparam, int nsamples, int burn, 
	       int nbins, int sumtype, int wids, int nchains){
  int i, c;
  hid_t mvector;
  hsize_t start[2];  /* Start of hyperslab */
  hsize_t count[2] = {1,1};  /* Block count */
  hsize_t block[2];
  herr_t ret;
  hsize_t samdim[1];

  gsl_vector * catsample;
  catsample = gsl_vector_calloc(nchains * (nsamples - burn));

  /* create vector for buffer */
  samdim[0] = nsamples - burn;
  mvector = H5Screate_simple(1, samdim, NULL);
  /* loop through parameters */
 
  for (i=0; i<nparam; i++){ 
    if (wids == 1){
      fprintf(outfp,"%s_param_%d,",param,i);
    }
    start[0] = i; start[1] = burn;
    block[0] = 1; block[1] = (nsamples - burn);
    for (c=0; c<nchains; c++){
      ret = H5Sselect_hyperslab(dataspace, H5S_SELECT_SET, start, NULL, count, block);
      ret = H5Dread(dataset[c], H5T_NATIVE_DOUBLE, mvector, dataspace, H5P_DEFAULT, 
		    onesample->data);
      gsl_matrix_set_col(sample, c, onesample);
    }
    unwrapmatrix(sample, catsample, (nsamples - burn), nchains);
    /* estimate and credible intervals */
    if (sumtype == 0){
      calcci(catsample, credint, nchains * (nsamples - burn));
    }
    /* generate histogram */
    else if (sumtype == 1){
      calchist(catsample, hist, nchains * (nsamples - burn), nbins);
    }
    /* write to text file */
    else if (sumtype == 2){
      writetext(catsample, nchains * (nsamples - burn));
    }
    /* write diagnostics */
    else if (sumtype == 4){
      calcdiag(sample, catsample, (nsamples - burn), nchains);
    }
  }
  H5Sclose(mvector);
}

/* calculate summaries for single parameters, across MCMC steps only*/
void calcsimple(const char * param, hid_t dataspace, hid_t * dataset, gsl_matrix * sample,
		gsl_vector * onesample, gsl_histogram * hist, double credint,
		int nsamples, int burn, int nbins, int sumtype, int wids, int nchains){
  int c;
  hid_t mvector;
  hsize_t start[1];  /* Start of hyperslab */
  hsize_t count[1] = {1};  /* Block count */
  hsize_t block[1];
  herr_t ret;
  hsize_t samdim[1];

  gsl_vector * catsample;
  catsample = gsl_vector_calloc(nchains * (nsamples - burn));

  /* create vector for buffer */
  samdim[0] = nsamples - burn;
  mvector = H5Screate_simple(1, samdim, NULL);
  /* loop through parameters */
 
  if (wids == 1){
    fprintf(outfp,"%s,",param);
  }
  start[0] = burn;
  block[0] = (nsamples - burn);
  for (c=0; c<nchains; c++){
    ret = H5Sselect_hyperslab(dataspace, H5S_SELECT_SET, start, NULL, count, block);
    ret = H5Dread(dataset[c], H5T_NATIVE_DOUBLE, mvector, dataspace, H5P_DEFAULT, onesample->data);
    gsl_matrix_set_col(sample, c, onesample);
  }
  unwrapmatrix(sample, catsample, (nsamples - burn), nchains);

  /* estimate and credible intervals */
  if (sumtype == 0){
    calcci(catsample, credint, (nsamples - burn) * nchains);
  }
  /* generate histogram */
  else if (sumtype == 1){
    calchist(catsample, hist, (nsamples - burn) * nchains, nbins);
  }
  /* write to text file */
  else if (sumtype == 2){
    writetext(catsample, (nsamples - burn) * nchains);
  }
  /* calculate DIC */
  else if (sumtype == 3){
    calcdic(catsample, (nsamples - burn) * nchains);
  }
  /* write diagnostics */
  else if (sumtype == 4){
    calcdiag(sample, catsample, (nsamples - burn), nchains);
  }
  H5Sclose(mvector);
}

/* Function calculates and prints mean, median, and ci */
void calcci(gsl_vector * sample, double credint, int nsamples){
  double lb = (1.0 - credint)/2.0;
  double ub = 1.0 - lb;

  /* sort samples in ascending order */
  gsl_sort_vector(sample);
  fprintf(outfp,"%.6f,", gsl_stats_mean(sample->data, 1, nsamples));
  fprintf(outfp,"%.6f,", gsl_stats_median_from_sorted_data(sample->data, 1, nsamples));
  fprintf(outfp,"%.6f,", gsl_stats_quantile_from_sorted_data(sample->data, 1, nsamples,lb));
  fprintf(outfp,"%.6f\n", gsl_stats_quantile_from_sorted_data(sample->data, 1, nsamples,ub));
}

/* Function generates and prints a histogram of the posterior */
void calchist(gsl_vector * sample,  gsl_histogram * hist, int nsamples, int nbins){
  int i;
  double min = 0, max = 0;
  double upper = 0, lower = 0, midpoint = 0;
  
  min = gsl_vector_min(sample);
  max = gsl_vector_max(sample);
  max += max * 0.0001; /* add a small bit to max, as upper bound is exclusive */
  (void) gsl_histogram_set_ranges_uniform(hist, min, max);
  
  /* generate histogram */
  for (i=0; i<nsamples; i++){
    (void) gsl_histogram_increment(hist, gsl_vector_get(sample, i));
  }
  
  /* write histogram */
  for (i=0; i<nbins; i++){
    gsl_histogram_get_range(hist, i, &lower, &upper);
    midpoint = (lower + upper) / 2.0;
    if (i == 0){
      fprintf(outfp,"%.6f,%d", midpoint, (int) gsl_histogram_get(hist, i));
    }
    else{
      fprintf(outfp,",%.6f,%d", midpoint, (int) gsl_histogram_get(hist, i));
    }
  }
  fprintf(outfp, "\n");

}

/* Function prints the ordered samples from posterior as plain text */
void writetext(gsl_vector * sample,  int nsamples){
  int i = 0;

  fprintf(outfp,"%.5f", gsl_vector_get(sample, i));
  for (i=1; i<nsamples; i++){
    fprintf(outfp,",%.5f", gsl_vector_get(sample, i));
  }    
  fprintf(outfp,"\n");
}

int paramexists(const char * param){
  if(!strcmp("gprob", param)){ 
    return(1);
  }
  else if(!strcmp("zprob", param)){
    return(1);
  }
  else if(!strcmp("p", param)){
    return(1);
  }
  else if(!strcmp("q", param)){
    return(1);
  }
  else if(!strcmp("Q", param)){
    return(1);
  }
  else if(!strcmp("pi", param)){
    return(1);
  }
  else if(!strcmp("fst", param)){
    return(1);
  }
  else if(!strcmp("alpha", param)){
    return(1);
  }
  else if(!strcmp("gamma", param)){
    return(1);
  }
  else if(!strcmp("deviance", param)){
    return(1);
  }
  else{
    return(0);
  }
}

/* Function calculates and prints DIC */
void calcdic(gsl_vector * sample, int nsamples){
  double davg, dvar, dic;

  /* sort samples in ascending order */
  gsl_sort_vector(sample);
  davg = gsl_stats_mean(sample->data, 1, nsamples);
  dvar = gsl_stats_variance(sample->data, 1, nsamples);
  dic = davg + (0.5 * dvar);
  printf("Model deviance: %.2f\nEffective number of parameters: %.2f\nModel DIC: %.2f\n",
	 davg, (0.5 * dvar), dic);
}

/* Function calculates and prints MCMC diagnostics */
void calcdiag(gsl_matrix * sample, gsl_vector * catsample, int nsamples, int nchains){
  double ess, gelman;

  ess = calcess(sample, nsamples, nchains);
  if (nchains > 1){
    gelman = calcpsrf(sample, catsample, nsamples, nchains); /* R = Gelman & Rubin potential scale reduction factor */
    fprintf(outfp,"%.2f,%.3f\n",ess,gelman);
  }
  else 
    fprintf(outfp,"%.2f,NA\n",ess);
}

/* Function calculates and returns the effective sample size */
double calcess(gsl_matrix * sample, int nsamples, int nchains){
  double sum, mean, ac;
  double ess = 0;
  double minac = 0.01;
  int lag;
  int autoc = 1; /* boolean, set to zero when autoc drobs below 0.05 */
  int x;
  gsl_vector * onesample;
  onesample = gsl_vector_calloc(nsamples);

  mean = gsl_stats_mean(sample->data, 1, nsamples);

  for(x=0; x<nchains; x++){
    autoc = 1;
    gsl_matrix_get_col(onesample, sample, x);
    sum = 0;
    for(lag=1; autoc==1 && lag < nsamples; lag++){
      ac = lag_n_autocorrelation(onesample->data, mean, lag, nsamples);
      if (ac >= minac)
	sum += ac;
      else 
	autoc = 0;
    }  
    ess += (double) nsamples / (1 + 2 * sum);
  }
  gsl_vector_free(onesample);
  return ess;

}

/* Function calculates and returns Gelman's potential scale reduction factor */
double calcpsrf(gsl_matrix * sample, gsl_vector * catsample, int nsamples, int nchains){
  double B = 0;
  double W = 0;
  double var, mu, psrf, val;
  int x, i;

  gsl_vector * onesample;
  onesample = gsl_vector_calloc(nsamples);

  /* grand mean */
  mu = gsl_stats_mean(catsample->data, 1, (nsamples * nchains));
  
  /* within (W) and between (B) chain variance */
  for(x=0; x<nchains; x++){
    gsl_matrix_get_col(onesample, sample, x);
    W += gsl_stats_variance(onesample->data, 1, nsamples);
    val = gsl_stats_mean(onesample->data, 1, nsamples) - mu;
    B += val * val;
  }
  W = W/nchains;
  B = B * (double) ((nsamples)/(nchains-1));
  
  /* marginal posterior variance */
  var = ( (double) (nsamples - 1)/(nsamples)) * W + (double) 1/nsamples * B;
  psrf = sqrt(var/W);
  gsl_vector_free(onesample);
  return psrf;

}

double lag_n_autocorrelation(double x[], double mu, int n, int N){
  int i;
  double a = 0, b = 0;

  for(i=n; i<N; i++){
    a += (x[i] - mu) * (x[i-n] - mu);
    b += (x[i] - mu) * (x[i] - mu);
  }
  return (a/b);
  
} 

void writeLIG(const char * param, hid_t dataspace, hid_t * dataset, gsl_vector * sample,
	      int nloci, int nind, int ngeno, int wids, int nchains){
  int i, j, k, c;
  double ghat = 0;
  hid_t mvector;
  hsize_t start[3];  /* Start of hyperslab */
  hsize_t count[3] = {1,1,1};  /* Block count */
  hsize_t block[3];
  herr_t ret;
  hsize_t samdim[1];
  
  gsl_vector  * onesam;
  onesam = gsl_vector_calloc(ngeno);

  if (ngeno > 3){
    fprintf(stderr, "Genotype posterior summary is limited to bi-allelic data\n");
    exit(1);
  }

  /* create vector for buffer */
  samdim[0] = ngeno;
  mvector = H5Screate_simple(1, samdim, NULL);
    
  if (wids == 1){
    fprintf(outfp,"individual");
    for (i=0; i<nloci; i++){
      fprintf(outfp,",locus%d",i);
    }
    fprintf(outfp,"\n");
  }

  /* loop through loci and individuals */
  for (j=0; j<nind; j++){
    if (wids == 1)
      fprintf(outfp,"ind_%d,",j);
    for (i=0; i<nloci; i++){
      start[0] = i; start[1] = j; start[2] = 0;
      block[0] = 1; block[1] = 1; block[2] = ngeno;
      ghat = 0;
      for (c=0; c<nchains; c++){
	ret = H5Sselect_hyperslab(dataspace, H5S_SELECT_SET, start, NULL, count, block);
	ret = H5Dread(dataset[c], H5T_NATIVE_DOUBLE, mvector, dataspace, H5P_DEFAULT, 
		      onesam->data);
	for (k=1; k<ngeno; k++){
	  ghat += k * gsl_vector_get(onesam, k);
	}
      }
      gsl_vector_set(sample, i, ghat/(double) nchains);
    }
    writetext(sample, nloci);
  }

  H5Sclose(mvector);
  gsl_vector_free(onesam);

}

/* this function copys the content of a matrix M to a vector V, by row */
void  unwrapmatrix(gsl_matrix * m, gsl_vector * v, int d1, int d2){
  int i, j;

  for (i=0; i<d1; i++){
    for (j=0; j<d2; j++){
      gsl_vector_set(v,j + (d2 * i), gsl_matrix_get(m, i, j));
    }
  }

}

/* void writeLIA(const char * param, hid_t dataspace, hid_t dataset, int nloci, int nind, int npop, int wids){ */
/*   ; */
/* } */
