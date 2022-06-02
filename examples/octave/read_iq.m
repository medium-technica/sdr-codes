clc;
close all;
clear all;

flag = 0;

if flag
  rate_sampling = 2.4e6;
  rate_audio = 48e3;
  filename = "/home/abraham/github/medium-technica/sdr-codes/include/wbfm_raw_iq_2.4M_48k";
else
  rate_sampling = 2.4e6;
  rate_audio = 48e3;
  filename = "/home/abraham/github/medium-technica/sdr-codes/include/speech48000-nbfm2400000.iq";
end

bw = 8e3;

decimation = floor(rate_sampling/rate_audio)
fid = fopen (filename, "r");
val = fread(fid,"int16");
fclose (fid);
x_i = val([1:2:end]);
x_q = val([2:2:end]);
xc = x_i + x_q*i;
axis_f = linspace(0, rate_sampling, length(xc));
##subplot(411)
##plot(abs(fft(xc)));
xc_base = fn_bpf(xc, bw, floor(rate_sampling/2), rate_sampling);

##subplot(412)
##plot(axis_f, abs(fft(xc_base)))

xc_down = xc_base([1:decimation:end]);
phi = arg(xc_down);
phi_last = [0;phi(1:end-1)];
dphi = phi - phi_last;
dphi_o = dphi;
while (min(dphi_o) < -pi)
  dphi_o = dphi_o + (dphi_o < -pi) .* 2*pi;
end
while (max(dphi_o) > pi)
  dphi_o = dphi_o - (dphi_o > pi) .* 2*pi;
end
##subplot(413)
##plot(dphi_o)
x_demod = dphi_o-mean(dphi_o);
x_demod = fn_agc(x_demod, rate_audio);
player = audioplayer(x_demod, rate_audio);
play (player);
##subplot(414)
##plot(0.5*x_demod)


