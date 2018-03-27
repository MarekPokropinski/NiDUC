% Simulation of Binary Symmetric Channel
classdef BSChannel < handle

  properties
    % Working copy of current input
    curInput = 0;
    % Error probability
    BSCProb = 0.1;
  end

  methods
  
    % Simulates transmitting input through BSC
    function o = transmit(self, input)
      self.curInput = input;
      
      for i = 1 : length(self.curInput)
        if rand() < self.BSCProb
          self.curInput(i) = ~self.curInput(i);
        end
      end
      
      o = self.curInput;
      end
  end
  
end