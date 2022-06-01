# sdr-codes - Examples

## Dependencies:
1. 	[GNU Plot](http://www.gnuplot.info/) for plotting graphs:
2.	[FFTW3](https://www.fftw.org/) for Fast Fourier Transform

## References:
1. 	[Making C code plot a graph automatically](https://stackoverflow.com/a/6934363)
2. 	[Smallest power of 2 greater than or equal to n](https://www.geeksforgeeks.org/smallest-power-of-2-greater-than-or-equal-to-n/)

## Sample command:
linking is required when `fftw3` is used:
```
 gcc file_name.c -lfftw3 -lm
 ./a.out
```