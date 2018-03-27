% Simulation of Gilbert Elliot model
classdef GEChannel < handle

  properties
    % Probabilty of bad -> good transition
    gilbertGoodProb = 0.6;
    % Probability of good -> bad transition
    gilbertBadProb = 0.2;
  end

  properties (Access = private)
    % Working copy of current input
    curInput = 0;
    % Current state of the simulator, 0 - good, 1 - bad
    curState = 0;
  end
  
  methods
  
    % Simulates transmitting input through Gilbert Elliot model
    function o = transmit(self, input)
      self.curInput = input;
      
      for i = 1 : length(self.curInput)
        self.updateState();
        
        if self.curState == 1
          self.flipInputBit(i);
        end
      end
      
      o = self.curInput;
    end
    
  end
  
  methods (Access = private)
     
    % Updates status of simulation (good / bad) basing on current status
    % and randomly generated number
    function updateState(self)
      random = rand();
        
      if self.curState == 0
        if random < self.gilbertBadProb
          self.curState = 1;
        end
      else
        if random < self.gilbertGoodProb
          self.curState = 0;
        end
      end
    end
    
    % Flips bit on given index in input
    function flipInputBit(self, index)
      self.curInput(index) = ~self.curInput(index);
    end
  
  end
    
end
