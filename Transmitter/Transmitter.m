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
      self.mode = mode;
    end
    
    function data = sendPacketSW (self,packets,ack)      
        if ack==1
        self.curPacket=self.curPacket+1;
        if self.curPacket>columns(packets)
          data=[];
          return;
        end
      endif      
      data = packets(:,self.curPacket);
      data = self.createBracket(data);
    end
    
    function data = sendPacketsGBN(self,packets,window_size,ack)
      if ack{1}==1
        self.curPacket+=window_size;
      endif
      self.curPacket+=Transmitter.bin_to_num(ack{2});
      if self.curPacket>columns(packets)
        data = [];
        return;
      end
      last_pack = self.curPacket+window_size-1;
      if last_pack>columns(packets)
        last_pack=columns(packets);
      endif          
      data = transpose(packets(:,self.curPacket:last_pack));
      data = cat(2,zeros(rows(data),4),data);
      for i=1:window_size
        data(i,1:4)=Transmitter.num_to_bin(i-1,4);
      end
      data=transpose(self.createBracket(transpose(data)));
    end
    
    function data = sendPacketsSR(self,packets,window_size,ack)      
      if length(ack)>0 && ack(1)==-1
        ack=[];
        self.curPacket=1-window_size;
      end
      if length(ack)==0
        self.curPacket+=window_size;
        if self.curPacket>columns(packets)
          data = [];
          return;
        end
        last_pack = self.curPacket+window_size-1;
        if last_pack>columns(packets)
          last_pack=columns(packets);
        endif
        data = transpose(packets(:,self.curPacket:last_pack));
        data = cat(2,zeros(rows(data),4),data);
        for i=1:window_size
          data(i,1:4)=Transmitter.num_to_bin(i-1,4);
        end
        data=transpose(self.createBracket(transpose(data)));
      else
        for i=1:length(ack)
          if self.curPacket+ack(i)<=columns(packets)
            data(i,:)=transpose(packets(:,self.curPacket+ack(i)));          
          else
            data(i,:)=zeros(1,self.packet_size);
          end          
        end
        data = cat(2,zeros(rows(data),4),data);
        for i=1:window_size
          data(i,1:4)=Transmitter.num_to_bin(i-1,4);
        end
        data=transpose(self.createBracket(transpose(data)));
      end
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
      #ret = self.createBracket(ret);
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
    
    function num = bin_to_num(arr)
      num=0;
      for i=1:length(arr)
        num*=2;
        num+=arr(i);
      endfor
    endfunction
    
    function bin = num_to_bin(num,len)
      for i=1:len
        bin(len-i+1)=mod(num,2);
        num=floor(num/2);
      end
    end
    
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