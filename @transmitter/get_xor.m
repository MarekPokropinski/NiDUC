function p = get_xor(data)
  x = 0;
  for i=1:length(data)
    x = xor(x,data(i));
  endfor
  p=[x];
endfunction

  