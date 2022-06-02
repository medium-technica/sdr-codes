function y = fn_bpf(x,fl,fu,fs)
  nfl = floor(length(x)/fs * fl)
  nfu = ceil(length(x)/fs * fu)
  xk = fft(x);
  xk(nfl:nfu) = 0;
  xk(length(x)-nfu:length(x)-nfl) = 0;
  y = ifft(xk, length(x));
end

