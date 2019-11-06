#include <cov_log.h>
#include <cov_checker.h>

#include <time.h>
#include <stdarg.h>
#include <inttypes.h>
#include <math.h>
#include <stdio.h>

extern uint64_t current_time_ns(void);
#define ITERS 1

long double fun(long double x) {
  long double pi = acos(-1.0);
  long double result;
  result = sin(pi * x);
  return result;
}

int main( int argc, char **argv) {

  /****** BEGIN PRECIMONIOUOS PREAMBLE ******/
  // variables for logging/checking
  long double epsilon = -8.0;
  long double threshold = 0.0;
  int l;

  // variables for timing measurement
  uint64_t start, end;
  long int diff = 0;
  
  // dummy calls
  acosf(0);
  sinf(0);
  /****** END PRECIMONIOUOS PREAMBLE ******/

  int i, j, k; // diff: added constants
  const int n = 1000000;
  long double a, b;
  long double h, s1, x;
  const long double fuzz = 1e-26; // diff: added fuzz

  start = current_time_ns();
  for(l = 0; l < ITERS; l++) {
    a = 0.0;
    b = 1.0;
    h = (b - a) / (2.0 * n);
    s1= 0.0;

    x = a;
    s1 = fun(x);

  L100:
    x = x + h;
    s1 = s1 + 4.0 * fun(x);
    x = x + h;
    if (x + fuzz >= b) goto L110;
    s1 = s1 + 2.0 * fun(x);
    goto L100;

  L110:
    s1 = s1 + fun(x);

  }
  end = current_time_ns();
  diff += (long int)(end-start);

  /***** BEGIN PRECIMONIOUS ACCURACY CHECKING AND LOGGING ******/
  threshold = pow(10, epsilon)*s1;

  //cov_spec_log("spec.cov", threshold, 1, (long double)s1);
  cov_log("result", "log.cov", 1, (long double) s1);
  cov_check("log.cov", "spec.cov", 1);

  FILE* file;
  file = fopen("score.cov", "w");
  fprintf(file, "%ld\n", diff);
  fclose(file);
  /****** END PRECIMONIOUS ACCURACY CHECKING AND LOGGING ******/
  
  return 0;
}
