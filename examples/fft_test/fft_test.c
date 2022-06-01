#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "../../include/fft_ab.h"
#include "../../include/fftw3.h"

void print_ca(complex[], int);
void error(complex[], complex[], int len);
int main()
{
 int N = 8;
 complex in1[N], out1[N];
 fftw_complex *in, *out;
 fftw_plan p;
 in = (fftw_complex *)fftw_malloc(sizeof(fftw_complex) * N);
 out = (fftw_complex *)fftw_malloc(sizeof(fftw_complex) * N);

 for (int n = 0; n < N; n++)
 {
  in[n] = n;
 }
 p = fftw_plan_dft_1d(N, in, out, FFTW_FORWARD, FFTW_ESTIMATE);
 fftw_execute(p);

 print_ca(out, N);
 printf("\n");

 fft_ab(in, N, out1);
 print_ca(out1, N);
 printf("\n");
 error(out, out1, N);

 fftw_destroy_plan(p);
 fftw_free(in);
 fftw_free(out);
 return 0;
}

void print_ca(complex x[], int len)
{
 for (int i = 0; i < len; i++)
  printf("%d\t%f\t%f\n", i, creal(x[i]), cimag(x[i]));
}

void error(complex a[], complex b[], int len)
{
 printf("Error\n");
 complex y = 0;
 for (int i = 0; i < len; i++)
 {
  y = a[i] - b[i];
  printf("%f\t%f\n", creal(y), cimag(y));
 }
}
