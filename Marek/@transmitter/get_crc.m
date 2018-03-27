function p = get_crc(data)
  #a = [1,0,0,1,0,1,1,1,0,0,0,1,1,1,1,1,1,1,0,0,1,1,1,0,0,0,0,1,1,0,1,1,0];
  a = transpose([1,0,0,0,0,0,1,0,0,1,1,0,0,0,0,0,1,0,0,0,1,1,1,0,1,1,0,1,1,0,1,1,1]);
  
  #a=[1,0,1,1];
  
  d = cat(1,data,zeros(length(a)-1,1));
  
  len = length(data);
  for i=1:len
    if d(i)==1
      for x = 1:length(a)
        d(i+x-1)=xor(d(i+x-1),a(x));
      endfor      
    endif
  endfor
  p=d(len+1:len+length(a)-1);
endfunction
