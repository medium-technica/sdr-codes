clc;
close all
clear all;
fs = 8000;
f1 = 10;
f2 = 500;

fl = 300;
fu = 600;

t = [0:1/fs:0.5];
x1 = sin(2 * pi * f1 * t);
x2 = sin(2 * pi * f2 * t);

x = x1 + x2;
length(x)

y = fn_bpf(x, fl, fu, fs);

subplot(2, 1, 1)
plot(t,x)
subplot(2, 1, 2)
plot(t,y)
