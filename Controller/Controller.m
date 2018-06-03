
classdef Controller
  properties
    BER
    PER
    
  end
  methods(SetAccess = public)
    function ret = send(self,mode)
      global transmitter
      global channel
      global receiver
      global dataSize
      global generator
      global dataSize  
      
      disp('sending data');
      
      data = self.generate();
      packets = transmitter.prepareData(data);
      transmitter.reset();
      recvData = [];
      ackVec=[];
      bits = 0;
      
      i=0;
      
      if strcmp(mode,'sw')
        ack=0;
        while 1
          o = transmitter.sendPacketSW(packets,ack);
          if length(o)==0
            break
          end        
          o = channel.transmit(o);
          ack=receiver.sw(o);  
          i++;
          if i>10000
            disp('timeout!');
            break;
          end
        end
      elseif strcmp(mode,'gbn')
        ack={0,[0,0,0,0]};
        while 1
          o = transmitter.sendPacketsGBN(packets,16,ack);
          if length(o)==0
            break
          end        
          o = channel.transmit(o);
          ack=receiver.gbn(o,4);  
          i++;
          if i>1000000
            disp('timeout!');
            break;
          end
        end
      #elseif strcmp(mode,'sn')
      end
        
      data = transpose(reshape(data,transmitter.packet_size,[]));
      rdata = transpose(reshape(receiver.received_data,transmitter.packet_size,[]));
      
      #data(1:3,:)
      #rdata(1:3,:)
      
      com = Comparator();
      com.compare(data,rdata);
      
      self.BER = com.BER;
      self.PER = com.PER;
      
      disp('---------'); 
      disp(com.BER)
      disp 'per:'
      disp(com.PER)
      disp('bits transmitted:')
      disp(receiver.received_bits_total);
      disp('---------');
      global txt99;
      set(txt99,"string",num2str(com.BER));
      global txt98;
      set(txt98,"string",num2str(com.PER));
      global txt97;
      set(txt97,"string",num2str(receiver.received_bits_total));
    endfunction

    function data = generate(self)
      global generator
      global dataSize
      global transmitter
      data = generator.getVector(dataSize);      
    end    
  end
end

  
    
    
