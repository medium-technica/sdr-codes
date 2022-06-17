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
bw = 1.5*rate_audio;
decimation = floor(rate_sampling/rate_audio)
fid = fopen (filename, "r");
val = fread(fid,"int16");
fclose (fid);
x_i = val([1:2:end]);
x_q = val([2:2:end]);
xc = x_i + x_q*i;
axis_f = linspace(0, rate_sampling, length(xc));
subplot(411)
plot(abs(fft(xc)));
xc_base = fn_bpf(xc, bw, floor(rate_sampling/2), rate_sampling);
xc_down = xc_base([1:decimation/10:end]);
subplot(412)
plot(abs(fft(xc_down)))
phi = arg(xc_down);
phi_last = [phi(2:end);0];
dphi = phi - phi_last;
dphi_o = dphi([1:decimation/5:end]);
while (min(dphi_o) < -pi)
  dphi_o = dphi_o + (dphi_o < -pi) .* 2*pi;
end
while (max(dphi_o) > pi)
  dphi_o = dphi_o - (dphi_o > pi) .* 2*pi;
end
subplot(413)
plot(dphi_o)
x_demod = dphi_o-mean(dphi_o);
x_demod = fn_agc(x_demod, rate_audio);
player = audioplayer(x_demod, rate_audio);
play (player);
subplot(414)
plot(0.5*x_demod)

