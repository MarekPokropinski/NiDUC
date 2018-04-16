classdef Receiver < handle

   properties (SetAccess = protected)
    packet_size
    mode
    final_matrix
   end
   
   methods (Access = public)
    
    function obj = Receiver(p, m)
      obj.packet_size = p;
      obj.mode = m;
    endfunction     %koniec konstruktora
    
%============= stop & wait ================
   
    function ack = sw (obj, received_vector, number_size, data_begining) 
      
      
      switch obj.mode
        case "par"
          data = received_vector(2:length(received_vector));
          if(xor(Receiver.get_parity(data), received_vector(1))),  
            ack=0;                      % ack- odpowied�; jak 1 to ok, jak 0 to �le
          else
            ack=1;
            %display(data);
          endif;
      
        case "crc"
          
          my_crc=transpose(Receiver.get_crc(data));
          received_crc = received_vector( (number_size + 1) : (data_begining -1));
          
          if(!xor(my_crc, received_crc)),  
            ack=1;
            display(data);                
          else
            ack=0;
          endif;
          
       endswitch
 
    endfunction

%============= go back N ==================

    function ack = gbn(obj, transmited_matrix, number_size, data_begining)

           
      for i=1:rows(transmited_matrix),    
  
        received_vector = transmited_matrix(i, 1:obj.packet_size);
        frame_number = received_vector(1:number_size);
        data = received_vector(data_begining:obj.packet_size);
  
       switch obj.mode
        case "par"
      
          if(xor(Receiver.get_parity(data), received_vector(number_size + 1))),  
            ack=[0, frame_number];  % jak co� jest nie tak, to wysy�am 0 i numer b��dnego pakietu
            break;                  % wychodz� z p�tli, bo ju� nie b�d� pobiera� kolejnych pakiet�w
          else
            ack=1;
            frame_number=num2str(frame_number);
            frame_number=bin2dec(frame_number);
            obj.final_matrix(frame_number,1:(obj.packet_size-data_begining+1))=data;
          endif;
      
        case "crc"
        
            my_crc=transpose(Receiver.get_crc(data));
            received_crc = received_vector( (number_size + 1) : (data_begining -1));
            
            if(!xor(my_crc, received_crc)),  
              ack=1;
              frame_number=num2str(frame_number);
              frame_number=bin2dec(frame_number);
              obj.final_matrix(frame_number,1:(obj.packet_size-data_begining+1))=data;
            else
              ack=[0, frame_number];    
              break; 
            endif;
        
       endswitch;
  
      endfor;
    endfunction
    
    %============= selective repeat ==================

    function ack = sr(obj, transmited_matrix, number_size, data_begining)

      ack(1)=1;
      n=obj.packet_size;  
      counter=1;                  %zmienna pomocnicza przy tworzeniu ack      
    
      for i=1:rows(transmited_matrix), 
        received_vector = transmited_matrix(i, 1:n);
        frame_number = received_vector(1:number_size);
        data = received_vector(data_begining:n);
  
        switch obj.mode
         case "par"
      
          if(xor(Receiver.get_parity(data), received_vector(number_size + 1))),  
            ack(1,1:number_size)=0;
            counter=counter+1;
            ack(counter, 1:number_size)=frame_number;
             
          else
            frame_number=num2str(frame_number);
            frame_number=bin2dec(frame_number);
            obj.final_matrix(frame_number,1:(n-data_begining+1))=data;
          endif;
      
         case "crc"
        
            my_crc=transpose(Receiver.get_crc(data));
            received_crc = received_vector( (number_size + 1) : (data_begining -1));
            
            if(!xor(my_crc, received_crc)),
              frame_number=num2str(frame_number);
              frame_number=bin2dec(frame_number);
              obj.final_matrix(frame_number,1:(n-data_begining+1))=data;
            else
              ack(1,1:number_size)=0;
              counter=counter+1;
              ack(counter, 1:number_size)=frame_number;   
            endif;
    
        endswitch; 
      endfor;
    
    endfunction
    
      
    
    end %koniec metod niestatycznych
    
    methods(Static)
    
%======= metoda do licznia bitu parzysto�ci =====================
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