clc;
close all;
clear all;
flag = 1;
if flag
  rate_sampling = 2.4e6;
  rate_audio = 100e3;
  filename = "../../include/wbfm_raw_iq_2.4M_120k.iq";
else
  rate_sampling = 2.4e6;
  rate_audio = 100e3;
  filename = "../../include/speech48000-nbfm2400000.iq";
end
bw = 200e3;
decimation = floor(rate_sampling/rate_audio)

decimation_1 = decimation / 12;
decimation_2 = decimation / 2;

fid = fopen (filename, "r");
val = fread(fid,"int16");
fclose (fid);
x_i = val([1:2:end/6]);
x_q = val([2:2:end/6]);
xc = x_i + x_q*i;
axis_f = linspace(-rate_sampling/2, rate_sampling/2, length(xc));
subplot(411)
plot(axis_f, abs(fftshift(fft(xc))));
title("Spectrum of RAW IQ");

xc_base = fn_bpf(xc, bw/2, floor(rate_sampling/2), rate_sampling);
subplot(412)
plot(axis_f,abs(fftshift(fft(xc_base))));
title("Spectrum after LPF");

xc_down = xc_base([1:decimation_1:end]);
axis_f = linspace(-rate_sampling/(decimation_1*2), rate_sampling/(decimation_1*2), length(xc_down));
subplot(413)
plot(axis_f, abs(fftshift(fft(xc_down))));
title(sprintf ("Spectrum after first stage Decimation by %d samples", decimation_1));

t1 = [0:1/rate_audio:(1/rate_audio)*(length(xc_down)-1)];
fStereoPilot = 10e3;
lo = exp(-2*pi*j*fStereoPilot*t1);
fms = xc_down .* 1;
f_axis = linspace(-rate_audio, rate_audio, length(lo));
subplot(414)
plot(f_axis, fftshift(abs(fft(fms))))


