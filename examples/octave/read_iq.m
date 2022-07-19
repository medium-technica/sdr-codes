clc;
close all;
clear all;
flag = 1;
if flag
  rate_sampling = 2.4e6;
  rate_audio = 120e3;
  filename = "../../include/wbfm_raw_iq_2.4M_120k.iq";
else
  rate_sampling = 2.4e6;
  rate_audio = 120e3;
  filename = "../../include/speech48000-nbfm2400000.iq";
end
bw = 200e3;
decimation = floor(rate_sampling/rate_audio)

decimation_1 = decimation / 10;
decimation_2 = decimation / 2;

fid = fopen (filename, "r");
val = fread(fid,"int16");
fclose (fid);
x_i = val([1:2:end]);
x_q = val([2:2:end]);
xc = x_i + x_q*i;
axis_f = linspace(-rate_sampling/2, rate_sampling/2, length(xc));
subplot(711)
plot(axis_f, abs(fftshift(fft(xc))));
title("Spectrum of RAW IQ");

xc_base = fn_bpf(xc, bw, floor(rate_sampling/2), rate_sampling);
subplot(712)
plot(axis_f,abs(fftshift(fft(xc_base))));
title("Spectrum after LPF");

xc_down = xc_base([1:decimation_1:end]);
axis_f = linspace(-rate_sampling/(decimation_1*2), rate_sampling/(decimation_1*2), length(xc_down));
subplot(713)
plot(axis_f, abs(fftshift(fft(xc_down))));
title(sprintf ("Spectrum after first stage Decimation by %d samples", decimation_1));

phi = arg(xc_down);
phi_last = [phi(2:end);0];
dphi = phi - phi_last;

axis_t = linspace(0, length(dphi)/(rate_sampling/decimation_1), length(dphi));
subplot(714);
plot(axis_t, dphi);
title("Demodulated Signal (Phase values)");

dphi_o = dphi([1:decimation_2:end]);
axis_t = linspace(0, length(dphi_o)/(rate_sampling/decimation), length(dphi_o));
subplot(715)
plot(axis_t, dphi_o)
title(sprintf ("Phase values after second stage of decimation by %d samples", decimation_2));

while (min(dphi_o) < -pi)
  dphi_o = dphi_o + (dphi_o < -pi) .* 2*pi;
end
while (max(dphi_o) > pi)
  dphi_o = dphi_o - (dphi_o > pi) .* 2*pi;
end
subplot(716)
plot(axis_t, dphi_o)
title("Phase Values corrected to within +/- pi");
%x_demod = dphi_o-mean(dphi_o);
x_demod = fn_agc(dphi_o, rate_audio/5);
subplot(717)
plot(axis_t, x_demod)
title("Phase values after Gain Adjustment");
player = audioplayer(x_demod, rate_audio);
play (player);
length(x_demod) / rate_audio

