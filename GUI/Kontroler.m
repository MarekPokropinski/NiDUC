classdef Kontroler < handle
    properties(SetAccess = protected)
      _Transmitter
      _Receiver
      _Channel
      Time
    end
    methods(SetAccess = public)
        function con=Kontroler()
          self._Transmitter=Transmitter;
          self._Receiver=Receiver;
          self._Channel=Channel;
          self.Time=10;
        end 
        function Run()
     while true
        _Transmitter.Update(self.Time*self.scale);
        _Receiver.Update(self.Time*self.scale);
        _Channel.Update(self.Time*self.scale);
        Pause(self.Time)
     endwhile
       endfunction
   endmethods
   end
      
  