#include <stdio.h>
#include <complex.h>
#define pi 3.1416
#define _2pi 6.2832

void fft_ab(complex in[], int len_N, complex out[])
{
 if (len_N > 2)
 {
  int len_half = len_N / 2;
  // Part A
  complex fa[len_half];
  int j = 0;
  for (int i = 0; i < (len_N - 1); i = i + 2)
  {
   out[j] = in[i];
   out[len_half + (j++)] = in[i + 1];
  }
  fft_ab(out, len_half, fa);

  // Part B
  complex fb[len_half];
  fft_ab(out + len_half, len_half, fb);
  for (int k = 0; k < len_half; k++)
  {
   fb[k] = cexp(-I * _2pi / len_N * k) * fb[k];
   out[k] = fa[k] + fb[k];
   out[k + len_half] = fa[k] - fb[k];
  }
 }
 else
 {
  out[0] = in[0] + in[1];
  out[1] = in[0] - in[1];
 }
}
