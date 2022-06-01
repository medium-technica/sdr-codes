clc;
close all;
clear all;
rate_sampling = 2.4e6;
rate_audio = 48e3;
decimation = floor(rate_sampling/rate_audio)
%filename = "/home/abraham/github/medium-technica/sdr-codes/include/wbfm_raw_iq_250k_25k";
filename = "/home/abraham/github/medium-technica/sdr-codes/include/speech48000-nbfm2400000.iq";
fid = fopen (filename, "r");
val = fread(fid,"int16");
x_i = val([1:2:end]);
x_q = val([2:2:end]);
xc = x_i + x_q*i;
xc_down = xc([1:decimation:end]);
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
x_demod = 0.5 .* dphi_o / max(abs(dphi_o));
player = audioplayer(x_demod, rate_audio);
play (player);
plot(x_demod);
fclose (fid);

