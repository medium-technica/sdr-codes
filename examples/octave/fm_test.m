clc;
clear all;
close all;

Ac = 1;
Am = 1;
Fs = 2000;
Fc = 15;
Fm = 2;
Mi = 3;
n = [0:1/Fs:1];
xm = Am * sin(2 * pi * Fm * n);
xfm = Ac * sin(2 * pi * Fc * n + (Mi * xm));

xfm_demod = asin(xfm);

subplot(3,1,1)
plot(xm);
subplot(3,1,2)
plot(xfm)
subplot(3,1,3)
plot(xfm_demod)
