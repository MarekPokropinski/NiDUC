classdef Transmitter < handle
  properties(SetAccess = protected)
    packet_size
    curPacket
    mode
  endproperties

  methods (Access = public)
    function self = Transmitter(Packet_size,mode)
      self.packet_size=Packet_size;
      self.curPacket = 1;
    end
    
    function data = sendPacketSW (self,packets,ack)
      if ack==1
        self.curPacket=self.curPacket+1;
      endif      
      data = packets(:,self.curPacket);
    end
    
    function reset(self)
      self.curPacket=1;
    end    
    
    function packets = createPackets(self,data)
      padding = mod(self.packet_size-mod(rows(data),self.packet_size),self.packet_size);
      zero = zeros(padding,1);
      data = cat(1,data,zeros(padding,1));
      packets=(reshape(data,self.packet_size,[]));
    end
    
    function p = createBracket(self,packets)
      brackets = []; 
      for packet= packets
        if strcmp(self.mode,'crc')
          brackets = cat(2,brackets,Transmitter.get_crc(packet)); 
        else
          brackets = cat(2,brackets,Transmitter.get_xor(packet)); 
        endif
        
      end
      p = cat(1,brackets,packets);
    end 
  
    function ret = prepareData(self,data)
      ret = self.createPackets(data);
      ret = self.createBracket(ret);
    endfunction   
  
  
  end
  methods(Static)
    function p = get_xor(data)
      x = 0;
      for i=1:length(data)
        x = xor(x,data(i));
      endfor
      p=[x];
    endfunction
    
    function p = get_crc(data)
      a = transpose([1,0,0,0,0,0,1,0,0,1,1,0,0,0,0,0,1,0,0,0,1,1,1,0,1,1,0,1,1,0,1,1,1]);  
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
  end
end