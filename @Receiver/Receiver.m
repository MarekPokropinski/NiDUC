classdef Receiver < handle

   properties (SetAccess = protected)
    packet_size
    mode
    final_matrix
    received_data
    received_pos
    
    received_bits_total
    
    sr_buf_start
    sr_buf_completion
   end
   
   methods (Access = public)
    
    function obj = Receiver(p, m)
      obj.packet_size = p;
      obj.mode = m;
      obj.received_pos=1;
      obj.received_bits_total=0;
      obj.sr_buf_start=1;
      obj.sr_buf_completion=0;
    endfunction     %koniec konstruktora
    
    function ack = verify(obj,data,bracket)
      if strcmp(obj.mode,'par')
        ack = ! xor(Receiver.get_parity(data), bracket(1));
      elseif strcmp(obj.mode,'crc')
        my_crc=transpose(Receiver.get_crc(data));
        ack = 1;          
        for i=1:length(my_crc)
          if my_crc(i)!=bracket(i)
            ack=0;
          end
        end 
        
      end    
    endfunction
      
      
    function append_data(obj,data)
      for i=1:length(data)
        obj.received_data(obj.received_pos)=data(i);
        obj.received_pos+=1;
      end
    endfunction     
    
%============= stop & wait ================
   
    function ack = sw (obj, received_vector)     
      data=[];
      obj.received_bits_total += length(received_vector);
      switch obj.mode
        case "par"
          data = received_vector(2:length(received_vector));
          ack = obj.verify(data,received_vector(1:1));
        case "crc"        
          data = received_vector(33:length(received_vector));
          my_crc=transpose(Receiver.get_crc(data));
          received_crc = received_vector(1:32);
          ack = obj.verify(data,received_crc);                 
       endswitch 
       if ack
        obj.append_data(data);
       endif
    endfunction

%============= go back N ==================

    function ack = gbn(obj, transmited_matrix, number_size)
      obj.received_bits_total+=columns(transmited_matrix)*rows(transmited_matrix);
      #transmited_matrix = transpose(transmited_matrix);
      line_length = columns(transmited_matrix);
      bracket_size = line_length-obj.packet_size;
      
      for i=1:rows(transmited_matrix)  
       received_vector = transmited_matrix(i, :);
       frame_number = received_vector(bracket_size-number_size+1:bracket_size);
       data = received_vector(bracket_size+1:line_length);
  
       switch obj.mode
        case "par"
          ack1 = obj.verify(received_vector(2:line_length),received_vector(1:1));      
          if(ack1==0),  
            ack={0, Transmitter.num_to_bin(i-1,4)};  % jak co� jest nie tak, to wysy�am 0 i numer b��dnego pakietu
            break;                  % wychodz� z p�tli, bo ju� nie b�d� pobiera� kolejnych pakiet�w
          else
            ack={1,[0,0,0,0]};
            obj.append_data(data);
          endif;      
        case "crc"        
          ack1 = obj.verify(transpose(received_vector(33:length(received_vector))),received_vector(1:32)); 
          if(ack1==0),  
            ack={0, Transmitter.num_to_bin(i-1,4)};  % jak co� jest nie tak, to wysy�am 0 i numer b��dnego pakietu
            break;                  % wychodz� z p�tli, bo ju� nie b�d� pobiera� kolejnych pakiet�w
          else
            ack={1,[0,0,0,0]};
            obj.append_data(data);
          endif;    
       endswitch;  
      endfor;
    endfunction
    
    %============= selective repeat ==================

    function ack = sr(obj, transmited_matrix, number_size,window_size)
      ack = [];
      obj.received_bits_total+=columns(transmited_matrix)*rows(transmited_matrix);
      line_length = columns(transmited_matrix);
      bracket_size = line_length-obj.packet_size;
      
      for i=1:rows(transmited_matrix)
         if obj.sr_buf_completion==window_size
           obj.sr_buf_completion=0;
           obj.sr_buf_start+=window_size*obj.packet_size;
         end
           
         received_vector = transmited_matrix(i, :);
         frame_number = received_vector(bracket_size-number_size+1:bracket_size);
         data = received_vector(bracket_size+1:line_length);
    
         switch obj.mode
          case "par"
            ack1 = obj.verify(received_vector(2:line_length),received_vector(1:1));      
            if(ack1==0),  
              ack=[ack,i-1];               
            else
              seq = cast(Transmitter.bin_to_num(frame_number),"uint32");
              for i=1:length(data)
                obj.received_data(i+obj.sr_buf_start+seq*obj.packet_size-1)=data(i);
              end
              obj.sr_buf_completion+=1;
            endif;      
          case "crc"        
            ack1 = obj.verify(transpose(received_vector(33:length(received_vector))),received_vector(1:32)); 
            if(ack1==0),  
              ack=[ack,i-1];               
            else
              seq = cast(Transmitter.bin_to_num(frame_number),"uint32");
              for i=1:length(data)
                obj.received_data(i+obj.sr_buf_start+seq*obj.packet_size-1)=data(i);
              end
              obj.sr_buf_completion+=1;
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
      %data = transpose(data);
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
