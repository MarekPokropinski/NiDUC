function callbacks(h,event,arg)
  global generator;
  global transmitter;
  global data;
  global dataSize;  
  global channel;
  global receiver;
  global p_Odbiornik;
  global p_Kanal;
  global p_Nadajnik;
  
  global mode;
  global chsum;
  global dataSize_str;
  global packetSize;
  
  global bsc_prob;
  global gilbert_good;
  global gilbert_bad;
  
  try  
    switch arg
      case 3 # start button
        disp('Start!');
        
        con = Controller();
        
        disp(mode)
        disp(packetSize)
        disp(dataSize_str)
        disp(chsum)
        fflush(stdout)
        
        packet_size = str2num(packetSize);    
        disp(packet_size);
        transmitter = Transmitter(packet_size,chsum);
        receiver = Receiver(packet_size,chsum);
        
        dataSize = str2num(dataSize_str);
        channel.setBSCProb(str2double(bsc_prob));
        channel.setGilbertGoodProb(str2double(gilbert_good));
        channel.setGilbertBadProb(str2double(gilbert_bad));     
        
        fflush(stdout)
        
        con.send(mode);
        disp('finished sending data');
      
      
      case 4 # sw
        mode = 'sw';      
      case 5 # gbn
        mode = 'gbn';      
      case 6 # sr
        mode = 'sr';
      case 7
        dataSize_str = get(h,'string');
      case 8
        packetSize = get(h,'string');
      case 9
        chsum= 'par';
      case 10
        chsum = 'crc';
      case 11
        bsc_prob = get(h,'string');
      case 12
        gilbert_good = get(h,'string');
      case 13
        gilbert_bad = get(h,'string');      
      
    endswitch
  
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