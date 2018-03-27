function p = getVector(obj,size)
  if (obj.seed!=0)
    rand("seed",obj.seed);
  else
    rand("state","reset");
  endif
  
  p = randi([0 1],size,1,class="uint8");
  #p = randi([0 1],size,1,class="logical");
endfunction

  
    
  