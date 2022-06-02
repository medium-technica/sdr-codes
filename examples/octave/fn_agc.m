function y = fn_agc(x, fs)
  n_frame = ceil(fs/5);
  for i = 1:length(x)-n_frame
    y(i) = x(i) ./ max(x(i:i+n_frame));
  endfor
  y((length(x)-n_frame):length(x)) = x((length(x)-n_frame):length(x))./max((length(x)-n_frame):length(x));
end

