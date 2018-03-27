% Simulates communication channel with BSC and Gilbert error models
classdef Channel < handle
  
  properties
    % Status flag of BSC simulator, 0 - off, 1 - on
    BSCStatus = 0;
    % Status flag of Gilbert model simulator, 0 - off, 1 - on
    gilbertStatus = 0;
  end
  
  properties (Access = private)
    % Working copy of current input
    curInput = 0;
    % BSC simulator object
    BSCSim = BSChannel;
    % Gilbert model simulator object
    gilbertSim = GEChannel;
  end
  
  methods
  
    % Simulates trsmitting input over channel with BSC and Gilbert error models
    % applied basing on flags
    function o = transmit(self, input)
      self.curInput = input;
      
      if self.BSCStatus == 1
        self.curInput = self.BSCSim.transmit(self.curInput);
      end
      
      if self.gilbertStatus == 1
        self.curInput = self.gilbertSim.transmit(self.curInput);
      end
      
      o = self.curInput;
    end
    
    % Sets BSC error probability to given value
    function setBSCProb(self, prob)
      self.BSCSim.BSCProb = prob;
    end
    
    % Sets Gilbert model bad -> good transition probability to given value
    function setGilbertGoodProb(self, prob)
      self.gilbertSim.gilbertGoodProb = prob;
    end
    
    % Sets Gilbert model good -> bad transition probability to given value
    function setGilbertBadProb(self, prob)
      self.gilbertSim.gilbertBadProb = prob;
    end
  
  end
  
end