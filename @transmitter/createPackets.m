function packets = createPackets(obj,data)
  
  padding = obj.packet_size-mod(rows(data),obj.packet_size);
  tab = num2cell(data);
  
  for i = (rows(data)+1):(rows(data)+padding)  
    tab(i)=0;  
  endfor
  
  packets=transpose(reshape(cell2mat(tab),obj.packet_size,[]));  
endfunction