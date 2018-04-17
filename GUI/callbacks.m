function callbacks(h,event,arg)
  global generator;
  global transmitter;
  global data;
  global dataSize=48;  
  global channel;
  global receiver;
  global p_Odbiornik;
  global p_Kanal;
  global p_Nadajnik;
  
  try  
    if arg == 0
      val = get(h,"value");
      txt3=uicontrol("parent",p_Kanal,"style","text","position",[220 640 150 20]);
      set(txt3,"string",num2str(val));
      channel.setBSCProb(val);
    end
    if arg == 1
      val = get(h,"value");
      txt3=uicontrol("parent",p_Kanal,"style","text","position",[220 490 150 20]);
      set(txt3,"string",num2str(val));      
    end
    if arg == 2      
      data = generator.getVector(dataSize);
      pack = transpose(transmitter.prepareData(data));
      i=1;
      while i<=dataSize/transmitter.packet_size
          output_text=uicontrol("parent",p_Nadajnik,"style","text","position",[100 650-20*i 150 20]);
          set(output_text,"String",mat2str(pack(i,:)));
          i++;
      endwhile
    end
    if arg == 3
      
      transmitter.reset();
      
      recvData = [];
      ackVec=[];
      bits = 0;

      packets = transmitter.prepareData(data);
      ack=0;
      i=1;
      while bits<dataSize  
        o = transmitter.sendPacketSW(packets,ack);
        o = channel.transmit(o);
        recvData(i,1:length(o))=o;
        ack=receiver.sw(o,length(o)-1,1);
        ackVec(length(ackVec)+1)=ack;
        if ack==1
          bits+=transmitter.packet_size;
        end
        i++;
      end

      i=1;
      while i<=size(recvData,1)
        output_text=uicontrol("parent",p_Odbiornik,"style","text","position",[50 650-20*i 100 20]);
        output_text2=uicontrol("parent",p_Odbiornik,"style","text","position",[200 650-20*i 150 20]);
        set(output_text,"String",mat2str(recvData(i,:)));
        set(output_text2,"String",num2str(ackVec(i)));
        i++;
      endwhile
      while i < 50
        output_text=uicontrol("parent",p_Odbiornik,"style","text","position",[50 650-20*i 100 20]);
        output_text2=uicontrol("parent",p_Odbiornik,"style","text","position",[200 650-20*i 150 20]);
        set(output_text,"String"," ");
        set(output_text2,"String"," ");
        i++;
      end
    end
  catch exception
  
  end


endfunction


%global checkbox1;
%  global checkbox1_value=get(checkbox1,'value');
%  if(checkbox1_value==1)
%    global p_Kanal;
%    global gui;
%    global channel;
%    n=get(h,"value");
 %   txt3=uicontrol("parent",p_Kanal,"style","text","position",[220 635 150 20]);
 %   set(txt3,"string",num2str(n));
 % endif