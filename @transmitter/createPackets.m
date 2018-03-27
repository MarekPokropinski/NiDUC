function packets = createPackets(obj,data)
  
  padding = obj.packet_size-mod(rows(data),obj.packet_size);
  
  data = cat(1,data,zeros(1,padding));
    
  packets=(reshape(data,obj.packet_size,[]));
endfunction