% Simulation of Gilbert Elliot model
classdef GEChannel < handle

  properties
    % Working copy of current input
    curInput = 0;
    % Probabilty of bad -> good transition
    gilbertGoodProb = 0.9;
    % Probability of good -> bad transition
    gilbertBadProb = 0.1;
  end

  methods
  
    % Simulates transmitting input through Gilbert Elliot model
    function o = transmit(self, input)
      self.curInput = input;
      
      % Work in progress
      
      o = self.curInput;
    end
  
  end
    
end