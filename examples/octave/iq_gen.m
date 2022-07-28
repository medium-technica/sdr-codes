clc;
close all;
clear all;

rate_sampling = 2.4e6;
rate_audio = 100e3;

t_iq = [0:1/rate_sampling:0.05];
t_audio = [0:1/rate_audio:5];

f1 = 440;

iq = exp(j*2*pi*f1*t_iq);
plot(t_iq, iq);
