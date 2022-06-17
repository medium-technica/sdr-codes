clc;
clear all;
close all;

Ac = 1;
Am = 1;
Fs = 2000;
Fc = 20;
Fm = 2;
Mi = 3;
n = [0:1/Fs:1];
xm = Am * cos(2 * pi * Fm * n);
xfm = Ac * sin(2 * pi * Fc * n + (Mi * xm));

xfm_phi = asin(xfm)./Ac;
xfm_phi_last = [xfm_phi(2:end),0];

xfm_demod = abs(xfm_phi_last - xfm_phi);
xfm_demod = xfm_demod - mean(xfm_demod);
xfm_demod = fn_bpf(xfm_demod, 5, floor(Fs/2), Fs);
xfm_demod = xfm_demod ./ max(xfm_demod);

subplot(3,1,1)
plot(xm);
subplot(3,1,2)
plot(xfm)
subplot(3,1,3)
plot(real(xfm_demod))
