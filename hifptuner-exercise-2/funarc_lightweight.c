#include <cov_log.h>
#include <cov_checker.h>

#include <time.h>
#include <inttypes.h>
#include <math.h>
#include <stdio.h>

extern uint64_t current_time_ns(void);
#define ITERS 1

long double fun( long double x ) {
  int k, n = 5;
  long double t1, d1 = 1.0L;

  t1 = x;

  for( k = 1; k <= n; k++ )
  {
    d1 = 2.0 * d1;
    t1 = t1 + sin (d1 * x) / d1;
  }

  return t1;
}

int main() {

  /****** BEGIN PRECIMONIOUOS PREAMBLE ******/
  // variables for logging/checking
  long double epsilon = -6.0;
  long double threshold = 0.0;
  int l;

  // variables for timing measurement
  uint64_t start, end;
  long int diff = 0;
  
  // dummy calls to alternative functions
  sqrtf(0);
  acosf(0);
  sinf(0);
  /****** END PRECIMONIOUOS PREAMBLE ******/
  
  int i, j, k, n = 1000000;
  long double h, t1, t2, dppi;
  long double s1;
  
  start = current_time_ns();
  for (l = 0; l < ITERS; l++) {
    t1 = -1.0;
    dppi = acos(t1);
    s1 = 0.0;
    t1 = 0.0;
    h = dppi / n;

    for( i = 1; i <= n; i++ ) {
      t2 = fun (i * h);
      s1 = s1 + sqrt (h*h + (t2 - t1)*(t2 - t1));
      t1 = t2;
    }
  }
  end = current_time_ns();
  diff = (end-start);

  /***** BEGIN PRECIMONIOUS ACCURACY CHECKING AND LOGGING ******/
  threshold = s1*pow(10, epsilon);

  // cov_spec_log("spec.cov", threshold, 1, s1);
  cov_log("result", "log.cov", 1, s1);
  cov_check("log.cov", "spec.cov", 1);


  FILE* file;
  file = fopen("score.cov", "w");
  fprintf(file, "%ld\n", diff);
  fclose(file);
  /****** END PRECIMONIOUS ACCURACY CHECKING AND LOGGING ******/

  return 0;
}


