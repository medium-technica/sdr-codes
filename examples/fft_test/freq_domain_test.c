/*
This program has the following dependencies:
1. 	GNU Plot for plotting graphs:
 http://www.gnuplot.info/

2.	FFTW3 Library for Fast Fourier Transform (if FFTW is set to 1)
 https://www.fftw.org/

References Used:
1. 	GNU Plot from C code:
 https://stackoverflow.com/a/6934363

2. 	Code for finding the next power of 2 of a given number
 https://www.geeksforgeeks.org/smallest-power-of-2-greater-than-or-equal-to-n/

Example Command to Execute this code (linking is required when fftw3 library is used (if FFTW is set to 1)):
 "gcc freq_domain_test.c -lfftw3 -lm"
 "./a.out"

*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "../include/fft_ab.h"
#include "../include/fftw3.h"

#define FFTW 0 // 0 for fft_ab, 1 for FFTW3

#define F1 5   // Frequency of Monotone Sinusoidal Signal 1 in Hz
#define A1 1   // Peak to Peak Amplitude of Signal 1
#define F2 50  // Frequency of Monotone Sinusiodal Signal 2 in Hz
#define A2 0.5 // Peak to Peak Amplitude of Signal 2
#define min_samples_per_cycle 3

int setFs(int, int);
float max(float, float);
uint nextPowerOf2(uint);
void fft(complex[], complex[], uint);
void plot(int, complex[], complex[], complex[], complex[]);
int main()
{
  uint Fs = setFs(F1, F2);
  complex x1[Fs], x2[Fs], x[Fs], x_fft[Fs];
  for (int n = 0; n < Fs; n++)
  {
    x1[n] = A1 * sin(2 * 3.14 / Fs * F1 * n);
    x2[n] = A2 * sin(2 * 3.14 / Fs * F2 * n);
    x[n] = x1[n] + x2[n];
  }

  fft(x, x_fft, Fs);
  plot(Fs, x1, x2, x, x_fft);
  return 0;
}

void plot(int Fs, complex x1[], complex x2[], complex x[], complex x_fft[])
{
  FILE *temp[4];
  FILE *gnuplotPipe = popen("gnuplot -persist", "w");
  temp[0] = fopen("x1.temp", "w");
  temp[1] = fopen("x2.temp", "w");
  temp[2] = fopen("x.temp", "w");
  temp[3] = fopen("x_fft.temp", "w");
  for (int n = 0; n < Fs; n++)
  {
    float t = n / (float)Fs;
    fprintf(temp[0], "%f %f \n", t, creal(x1[n]));
    fprintf(temp[1], "%f %f \n", t, creal(x2[n]));
    fprintf(temp[2], "%f %f \n", t, creal(x[n]));
  }
  for (int k = 0; k < Fs; k++)
  {
    fprintf(temp[3], "%d %f \n", k, cabs(x_fft[k]));
  }
  fprintf(gnuplotPipe, "%s \n", "set key noautotitle");
  fprintf(gnuplotPipe, "%s \n", "set multiplot layout 4,1");
  fprintf(gnuplotPipe, "%s \n", "plot 'x1.temp' with lines title 'X1'");
  fprintf(gnuplotPipe, "%s \n", "plot 'x2.temp' with lines title 'X2'");
  fprintf(gnuplotPipe, "%s \n", "plot 'x.temp' with lines title 'X = X1 + X2'");
  fprintf(gnuplotPipe, "%s \n", "plot 'x_fft.temp' with lines title 'FFT of X'");
}

void fft(complex in[], complex out[], uint N)
{
  if (FFTW)
  {
    fftw_complex *ina, *outa;
    fftw_plan p;
    ina = (fftw_complex *)fftw_malloc(sizeof(fftw_complex) * N);
    outa = (fftw_complex *)fftw_malloc(sizeof(fftw_complex) * N);
    p = fftw_plan_dft_1d(N, in, out, FFTW_FORWARD, FFTW_ESTIMATE);
    fftw_execute(p);
    out = outa;
    fftw_destroy_plan(p);
    fftw_free(ina);
    fftw_free(outa);
  }
  else
  {
    fft_ab(in, N, out);
  }
}

int setFs(int f1, int f2)
{
  //int maxvalue = (f1 > f2) ? f1 : f2;
/*   if (max(f1, f2) == 0 || max(f1, f2) == f1)
  {
    maxvalue = f1;
  }
  else
  {
    maxvalue = f2;
  } */
  return nextPowerOf2(((f1 > f2) ? f1 : f2) * min_samples_per_cycle);
}

float max(float a, float b)
{
  if (a > b)
    return a;
  else if (a == b)
    return 0;
  else
    return b;
}

// https://www.geeksforgeeks.org/smallest-power-of-2-greater-than-or-equal-to-n/
uint nextPowerOf2(uint n)
{
  uint p = 1;
  if (n && !(n & (n - 1)))
    return n;

  while (p < n)
    p <<= 1;

  return p;
}
