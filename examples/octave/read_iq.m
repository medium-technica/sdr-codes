clc;
close all;
clear all;
flag = 1;
if flag
  rate_sampling = 2.4e6;
  rate_audio = 48e3;
  filename = "../../include/wbfm_raw_iq_2.4M_48k.iq";
else
  rate_sampling = 2.4e6;
  rate_audio = 48e3;
  filename = "../../include/speech48000-nbfm2400000.iq";
end
bw = 200e3;
decimation = floor(rate_sampling/rate_audio)
fid = fopen (filename, "r");
val = fread(fid,"int16");
fclose (fid);
x_i = val([1:2:end]);
x_q = val([2:2:end]);
xc = x_i + x_q*i;
axis_f = linspace(0, rate_sampling, length(xc));
subplot(711)
plot(abs(fftshift(fft(xc))));
title("Spectrum of RAW IQ");

xc_down = xc([1:2:end]);

subplot(712)
plot(abs(fftshift(fft(xc_down))));
title(sprintf ("Spectrum after first stage Decimation by %d samples", 2));

xc_base = fn_bpf(xc_down, bw/2, floor(rate_sampling/(2*2)), rate_sampling/2);
subplot(713)
plot(abs(fftshift(fft(xc_base))));
title("Spectrum after LPF");

phi = arg(xc_base);
phi_last = [phi(2:end);0];
dphi = phi - phi_last;
subplot(714);
plot(dphi);
title("Demodulated Signal (Phase values)");

dphi_o = dphi([1:25:end]);
subplot(715)
plot(dphi_o)
title("Phase values after second stage of decimation by 25 samples");

while (min(dphi_o) < -pi)
  dphi_o = dphi_o + (dphi_o < -pi) .* 2*pi;
end
while (max(dphi_o) > pi)
  dphi_o = dphi_o - (dphi_o > pi) .* 2*pi;
end
subplot(716)
plot(dphi_o)
title("Phase Values corrected to within +/- pi");

x_demod = dphi_o-mean(dphi_o);
x_demod = fn_agc(x_demod, rate_audio/2);
player = audioplayer(x_demod, rate_audio);
play (player);
subplot(717)
plot(0.5*x_demod)
title("Phase values after Gain Adjustment");
length(x_demod) / rate_audio

