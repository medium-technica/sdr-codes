function y = fn_fmDemod(fm_mod)
  phi = arg(fm_mod);
  phi_last = [phi(2:end);0];
  dphi = phi - phi_last;

  while (min(dphi) < -pi)
    dphi = dphi + (dphi < -pi) .* 2*pi;
  end
  while (max(dphi) > pi)
    dphi = dphi - (dphi > pi) .* 2*pi;
  end
  y = dphi;
 end
