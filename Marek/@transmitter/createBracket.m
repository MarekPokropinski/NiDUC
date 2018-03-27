function p = createBracket(obj,packets,fun)
  brackets = [];
  for packet= packets
    brackets = cat(2,brackets,fun(packet));    
  endfor
  p = cat(1,brackets,packets);
endfunction
