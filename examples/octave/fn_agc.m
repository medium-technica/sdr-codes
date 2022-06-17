function y = fn_agc(x, n_frame)
  l = length(x)
  ln_diff = length(x)-n_frame;
  for i = 1:n_frame:ln_diff
    x_t = x(i:i+n_frame);
    y(i:i+n_frame) = x_t ./ max(abs(x_t)) - mean(x_t);
  endfor
  x_t = x(ln_diff:end);
  y(ln_diff:l) = x_t./max(abs(x_t)) - mean(x_t);
end

