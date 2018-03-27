% Simulation of Binary Symmetric Channel
classdef BSChannel < handle

  properties
    % Error probability
    BSCProb = 0.1;
  end
  
  properties (Access = private)
    % Working copy of current input
    curInput = 0;
  end

  methods
  
    % Simulates transmitting input through BSC
    function o = transmit(self, input)
      self.curInput = input;
      
      for i = 1 : length(self.curInput)
        if rand() < self.BSCProb
          self.flipInputBit(i);
        end
      end
      
      o = self.curInput;
    end
    
  end
  
  methods (Access = private)
    
    % Flips bit on given index in input
    function flipInputBit(self, index)
      self.curInput(index) = ~self.curInput(index);
    end
    
  end
  
end
