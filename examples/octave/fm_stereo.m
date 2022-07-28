clc;
close all;
clear all;
flag = 1;
a = 7;
if flag
  rate_sampling = 2.4e6;
  rate_audio = 100e3;
  filename = "../../include/wbfm_raw_iq_2.4M_100k.iq";
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
x_i = val([1:2:end]);
x_q = val([2:2:end]);
xc = x_i + x_q*i;
axis_f = linspace(-rate_sampling/2, rate_sampling/2, length(xc));
subplot(a,1,1)
plot(axis_f, abs(fftshift(fft(xc))));
title("Spectrum of RAW IQ");

xc_base = fn_brf(xc, bw/2, rate_sampling-(bw/2), rate_sampling);
subplot(a,1,2)
plot(axis_f,abs(fftshift(fft(xc_base))));
title("Spectrum after LPF");

xc_down_1 = xc_base([1:decimation_1:end]);
axis_f = linspace(-rate_sampling/(decimation_1*2), rate_sampling/(decimation_1*2), length(xc_down_1));
subplot(a,1,3)
plot(axis_f, abs(fftshift(fft(xc_down_1))));
title(sprintf ("Spectrum after first stage Decimation by %d samples", decimation_1));

xc_down_2 = xc_down_1([1:decimation_2:end]);
axis_f = linspace(-rate_audio/2, rate_audio/2, length(xc_down_2));
subplot(a,1,4)
plot(axis_f, abs(fftshift(fft(xc_down_2))));
title(sprintf ("Spectrum after second stage Decimation by %d samples", decimation_2));

fm_demod = fn_fmDemod(xc_down_2);

t1 = [0:1/rate_audio:(1/rate_audio)*(length(xc_down_2)-1)];
t1(end)

fStereoPilot = 19165;
lo = exp(2*pi*j*fStereoPilot*t1);
fms_mod = xc_down_2 .* lo';
subplot(a,1,5)
plot(axis_f, fftshift(abs(fft(fms_mod))))

fms_mod = fn_brf(fms_mod, 5e3, rate_audio-5e3, rate_audio);
subplot(a,1,6)
plot(axis_f, fftshift(abs(fft(fms_mod))))

fms_demod = fn_fmDemod(fms_mod);

axis_t = linspace(0, length(fms_demod)/(rate_audio), length(fms_demod));
fms_demod = fn_agc(fms_demod, rate_audio/5);
fm_demod = fn_agc(fm_demod, rate_audio/5);
subplot(a,1,7)
plot(axis_t, fms_demod)
title("Phase values after Gain Adjustment");

fms_l = (fms_demod + fm_demod) / 2;
fms_r = -(fms_demod - fm_demod) / 2;
fms_2ch = [fms_l, fms_r];
player = audioplayer(fms_2ch, rate_audio);
play (player);

