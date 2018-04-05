classdef Transmitter < handle
  properties(SetAccess = protected)
    packet_size
    type
    data
    channel
    timeout    
    state
  endproperties
  

  methods (Access = public)
    
    function update(self,deltaTime)
      
      if self.type=='saw'
        self.stop_and_wait(deltaTime)
      endif      
    endfunction
    
    function stop_and_wait(self,deltaTime)
      self.state
      if strcmp(self.state , 'sending')        
        if length(self.data)==0
          self.state = 'end';
          break;
        endif
                
        pack = self.data(:,1);
        for i=1:length(pack)          
          self.channel.send(pack(i));
        endfor
        
        self.data=self.data(:,2:end);        
        self.state = 'wait';
        
        
      elseif strcmp(self.state , 'wait')
        if self.channel.getACK()
          self.state = 'sending';
        endif
        
      elseif strcmp(self.state , 'end')
        if length(self.data)>0
          self.state = 'sending';
        endif
      endif      
      
    endfunction
    
    function init(self)
      
      if strcmp(self.type,'saw')
        self.state = 'sending';
      endif      
    endfunction
  
    function self = Transmitter(packet_size,channel,type,timeout)
      self.packet_size=packet_size;
      self.type=type;
      self.channel=channel;
      self.timeout=timeout;
      
      self.init();      
    end
    
    function send(self,data,method)
      self.data=data;      
      self.data=self.createBracket(self.createPackets(data),method);
    endfunction
    
    
    function packets = createPackets(self,data)
      padding = mod(self.packet_size-mod(rows(data),self.packet_size),self.packet_size);
      zero = zeros(padding,1);
      data = cat(1,data,zeros(padding,1));
      packets=(reshape(data,self.packet_size,[]));
    end
    
    function p = createBracket(self,packets,method)
      brackets = [];
           
      
      for packet= packets
        if strcmp(method,'crc')
          brackets = cat(2,brackets,Transmitter.get_crc(packet)); 
        else
          brackets = cat(2,brackets,Transmitter.get_xor(packet)); 
        endif
        
      end
      p = cat(1,brackets,packets);
    end   
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