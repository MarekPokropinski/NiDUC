classdef DataGenerator < handle
  properties(SetAccess = protected)
    seed=0;
  endproperties
  
  methods
    function self = DataGenerator(seed)
        if (nargin==0)
           self.seed = 0;
        elseif (nargin==1)
           self.seed = seed;
        endif
    endfunction
     
    function p = getVector(obj,size)
      if (obj.seed!=0)
        rand("seed",obj.seed);
      else
        rand("state","reset");
      endif
      
      p = randi([0 1],size,1,class="uint8");
    endfunction
    
    function vector = loadFromFile(self,filename)
      f=fopen(filename,'rb');
      vector=fread(f,precision="uint8");
      fclose(f);
    endfunction

    function saveToFile(self,filename,vector)
      f = fopen(filename,"wb");
      fwrite(f,vector,precision="uint8");
      fclose(f);
    endfunction
     
  end
  
end