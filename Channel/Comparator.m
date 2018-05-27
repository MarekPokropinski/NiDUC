% Compares given vectors
classdef Comparator < handle

  properties
    % Bit Error Rate
    BER = 0;
    % Packet Error Rate
    PER = 0;
  end

  properties (Access = private)
    % Total number of packets
    packetsNum = 0;
    % Number of bits in packet
    packetLen = 0;
    % Total number of bits
    bitsNum = 0;
    % Number of bad bits
    badBitsNum = 0;
    % Number of bad packets
    badPacketsNum = 0;
  end
  
  methods
    
    % Calculates BER and PER of sent and received data
    function compare(self, sent, received)
      self.badBitsNum = 0;
      self.badPacketsNum = 0;
      
      self.packetsNum = length(sent);
      self.packetLen = length(sent(1,:));
      self.bitsNum = self.packetsNum * self.packetLen;
      
      packetGood = true;
      
      for i = 1 : self.packetsNum
        packetGood = true;
        
        for j = 1 : self.packetLen
          if sent(i, j) != received (i, j)
            self.badBitsNum = self.badBitsNum + 1;
            packetGood = false;
          end
        end
        
        if packetGood == false
          self.badPacketsNum = self.badPacketsNum + 1;
        end
      end
      
      self.BER = self.badBitsNum / self.bitsNum;
      self.PER = self.badPacketsNum / self.packetsNum;
    end
    
  end
  
end