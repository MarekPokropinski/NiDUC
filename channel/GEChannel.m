% Simulation of Gilbert Elliot model
classdef GEChannel < handle

  properties
    % Working copy of current input
    curInput = 0;
    % Current state of the simulator, 0 - good, 1 - bad
    curState = 0;
    % Probabilty of bad -> good transition
    gilbertGoodProb = 0.6;
    % Probability of good -> bad transition
    gilbertBadProb = 0.2;
  end

  methods
  
    % Simulates transmitting input through Gilbert Elliot model
    function o = transmit(self, input)
      self.curInput = input;
      
      for i = 1 : length(self.curInput)
        self.updateState();
        
        if self.curState == 1
          self.curInput(i) = ~self.curInput(i);
        end
      end
      
      o = self.curInput;
    end
     
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
  
  end
    
end