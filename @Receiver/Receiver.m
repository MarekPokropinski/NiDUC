classdef Receiver < handle

   properties (SetAccess = protected)
    packet_size
    window_size
    mode
   end
   
   methods (Access = public)
    
    function obj = Receiver(p, w, m)
      obj.packet_size = p;
      obj.window_size = w;
      obj.mode = m;
    endfunction     %koniec konstruktora
    
%============= stop & wait ================
   
    function ack = sw (obj, received_vector, number_size, data_begining) 
      n=obj.packet_size;              % n - liczba bitów całej ramki
      frame_number = received_vector(1:number_size);
      data = received_vector(data_begining:n);      
      
      if(obj.mode == "par"),
      
        if(xor(Receiver.get_parity(data), received_vector(number_size + 1))),  
          ack=0;                      % ack- odpowiedź; jak 1 to ok, jak 0 to źle
        else
          ack=1;
          display(data);
        endif;
      
      else
        if(obj.mode == "crc"),
          
          my_crc=transpose(Receiver.get_crc(data));
          received_crc = received_vector( (number_size + 1) : (data_begining -1));
          
          if(!xor(my_crc, received_crc)),  
            ack=1;
            display(data);                
          else
            ack=0;
          endif;
        endif;
      endif;
 
    endfunction

%============= go back N ==================

    function ack = gbn(obj, transmited_matrix, number_size, data_begining)

      n=obj.packet_size;            
      for i=1:obj.window_size,     %window_size - liczba wysyłanych na raz pakietów
  
        received_vector = transmited_matrix(i, 1:n);
        frame_number = received_vector(1:number_size);
        data = received_vector(data_begining:n);
  
        if(obj.mode == "par"),
      
          if(xor(Receiver.get_parity(data), received_vector(number_size + 1))),  
            ack=[0, frame_number];  % jak coś jest nie tak, to wysyłam 0 i numer błędnego pakietu
            break;                  % wychodzę z pętli, bo już nie będę pobierać kolejnych pakietów
          else
            ack=1;
            display(data);
          endif;
      
        else
          if(obj.mode == "crc"),
        
            my_crc=transpose(Receiver.get_crc(data));
            received_crc = received_vector( (number_size + 1) : (data_begining -1));
            
            if(!xor(my_crc, received_crc)),  
              ack=1;
              display(data); 
            else
              ack=[0, frame_number];    
              break; 
            endif;
          endif;
        endif;
  
      endfor;
    endfunction
    
    end %koniec metod niestatycznych
    
    methods(Static)
    
%======= metoda do licznia bitu parzystości =====================
    function p = get_parity(data)
      non_zero_bits= nnz(data);           
      p = mod(non_zero_bits,2);           %0-parzysta liczba jedynek, 1-nieparzysta
    endfunction
   
%======= metoda do liczenia CRC32 =============== 
    function p = get_crc(data)
      data = transpose(data);
      a = transpose([1,0,0,0,0,0,1,0,0,1,1,0,0,0,0,0,1,0,0,0,1,1,1,0,1,1,0,1,1,0,1,1,1]);  
      d = cat(1,data,zeros(length(a)-1,1));  
      len = length(data);
      for i=1:len
        if d(i)==1
          for x = 1:length(a)
            d(i+x-1)=xor(d(i+x-1),a(x));
          endfor      
        endif
      endfor
      p=d(len+1:len+length(a)-1);
    endfunction
 
 
   end  %koniec metod statycznych 
end     %koniec klasy
