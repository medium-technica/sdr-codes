clc;
close all;
clear all;

x = [5.*rand(1, 1000), 10.* rand(1, 1000)];
x = x-mean(x);
y = fn_agc(x, 10);

subplot(211);
plot(x);

subplot(212);
plot(y);
