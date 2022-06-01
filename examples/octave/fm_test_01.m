clc;
close all;
clear all;

## Sampling Frequency
 fs = 1000;

 ## Carrier Frequency
 fc = 20;

 ## Time Duration
 time = (0: 1 ./ fs:1)';

 ## Create two sinusoidal signals with frequencies 30 Hz and 60 Hz
 x = sin (2 .* pi .* 1 .* time) + 2 .* sin (2 .* pi .* 0 .* time);

 ## Frequency Deviation
 fDev = 0.1;

 ## Frequency modulate x
 y = fmmod (x, fc, fs, fDev);
length(y)
 ## plotting
## plot (time, x, 'r', time, y, 'b--')
## xlabel ('Time (s)')
## ylabel ('Amplitude')
## legend ('Original Signal','Modulated Signal')

plot(y(1:end))
