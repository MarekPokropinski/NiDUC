function obj = data_generator(seed)  
  if (nargin==0)
     obj.seed = 0;
  elseif (nargin==1)
     obj.seed = seed;
  endif
  obj = class(obj,"data_generator");
endfunction