classdef GUI_NIDUC
  properties(SetAccess=protected)
    _transmitter
    _receiver
    _channel
  end
  
  methods(SetAccess=public)
     function moja(h,event)
        global p_Kanal;
        n=get(h,"value");
        channel.setGilbertGoodProb(n);
        txt3=uicontrol("parent",p_Kanal,"style","text","position",[220 635 150 20]);
        set(txt3,"string",num2str(n));
    endfunction
  
      function con=GUI_NIDUC(transmitter,channel,receiver)
      self._Transmitter=transmitter;
      self._Receiver=receiver;
      self._Channel=channel;
      % create figure and panel on it
      f=figure();
      set(gcf, 'position',[100,100,1000,800]);
      %creat panels
      global p_Nadajnik = uipanel ("title", "Opcje", "position", [.0 0 .5 .95]);
      global p_Kanal = uipanel ("title", "Wynik", "position", [.5 0 .5 .95]);
      %global p_Odbiornik = uipanel ("title", "Odbiornik", "position", [.70 0 .30 .95]);
      % create a button group for channel
      gp = uibuttongroup (f, "Position", [ 0 0.95 1 0.2])
      % create a button group for header type
      gh= uibuttongroup(f, 'Position',[0 0.65 0.5 0.2])
      gz= uipanel('title','Zaklocenia','position',[0 0.25 0.5 0.25]);
      % create a buttons in the group
      b1 = uicontrol (gp,"value",1, "style", "radiobutton", ...
                      "string", "Stop-and-wait",'callback',{@callbacks,4}, ...
                      "Position", [120 15 100 15 ]);
      b2 = uicontrol (gp, "style", "radiobutton", ...
                      "string", "Go-Back-N",'callback',{@callbacks,5}, ...
                      "Position", [ 480 15 100 15 ]);
      b3 = uicontrol (gp, "style", "radiobutton", ...
                      "string", "Selective Repeat",'callback',{@callbacks,6}, ...
                      "Position", [ 800 15 150 15 ]);
      % create a buttons in the header group
      txt_header=uicontrol('parent',gh,'style','text','position',
                        [0 110 100 25],'string','Typ naglowka:');
      b4=uicontrol(gh,'style','radiobutton','string',
                     'Bit parzystosci','callback',{@callbacks,9},
                     'position', [20 70 125 25 ]);
      b5=uicontrol(gh,'style','radiobutton','string',
                    'CRC','callback',{@callbacks,10},
                    'position',[20 30 100 15]);
      % create a button not in the group
      txt = uicontrol('parent',p_Nadajnik,'Style','text',...
              'Position',[120 710 250 20],...
              'String','Ustawienia wiadomosci wychodzacej');
      %txt2 = uicontrol('parent',p_Odbiornik,'Style','text',...
         %     'Position',[20 710 140 20],...
          %    'String','Wiadomosc odebrana',"backgroundcolor",[0.8 0.2 0.3]); %%KOLOR
      %text=uicontrol("parent",p_Odbiornik,"style","text","string","ACK:","position",[200 670 150 20]);
       %gDane =uicontrol("parent",p_Nadajnik,"style","pushbutton","string","generuj Dane","callback",{@callbacks,2},
             %   "position",[100 50 100 100]);
      symDane =uicontrol("parent",p_Nadajnik,"style","pushbutton","string","Symulacja","callback",{@callbacks,3},
                  "position",[150 50 200 100]);
       %create sliders
      %slider1=uicontrol("parent",p_Kanal ,"Style","slider","min",0,"max",0.9,"value",0,"callback",{@callbacks,0},"Position",[30 600 300 15]); %'callback', {@nazwafucnkji}
      %slider2=uicontrol("parent",p_Kanal,'Style','slider',"min",0,"max",0.9,"value",0,"callback",{@callbacks,1},'Position',[30 450 300 15]);
      %slider3=uicontrol("parent",p_Kanal,"Style","slider","min",0,"max",0.9,"value",0.5,"Position",[30 300 300 15]);
      %slider4=uicontrol ("parent",p_Kanal,"Style","slider","min",0,"max",0.9,"value",0.7,"Position", [30 150 300 15]);
      %%%OUTPUT NADAJNIK
      txt_Ilosc=uicontrol('parent',p_Nadajnik,'style','text','position',[20 460 100 20],'string','ilosc bitow:');
      txt_Pakiety=uicontrol('parent',p_Nadajnik,'style','text','position',[20 430 100 20],'string','dlugosc pakietu');
      p_ilosc=uicontrol('parent',p_Nadajnik,"style",'edit',"Position", [130 460 50 20],'callback',{@callbacks,7});
      p_pakiety=uicontrol('parent',p_Nadajnik,'style','edit','Position',[130 430 50 20],'callback',{@callbacks,8});
      %%%POLE Z ZAKLĂ“CENIAMI
      txt_BSC1=uicontrol('parent',gz,'style','text','position',[20 50 100 20],'string','Gilbert good: ');
      txt_BSC2=uicontrol('parent',gz,'style','text','position',[20 100 100 20],'string','Gilbert bad: ');
      txt_Gilbert=uicontrol('parent',gz,'style','text','position',[20 150 100 20],'string','BSC: ');
      p_BSC=uicontrol('parent',gz,'style','edit','position',[120 50 50 20],'callback',{@callbacks,12});
      p_Gilbert1=uicontrol('parent',gz,'style','edit','position',[120 100 50 20],'callback',{@callbacks,13});
      p_Gilbert2=uicontrol('parent',gz,'style','edit','position',[120 150 50 20],'callback',{@callbacks,11});
      %%%OUTPUT ODBIORNIK
      txt_B_error=uicontrol('parent',p_Kanal,'style','text','position',[20 700 100 20],'string','Bit error rate: ');
      txt_P_error=uicontrol('parent',p_Kanal,'style','text','position',[20 650 120 20],'string','Packet error rate: ');
      txt_Bits_trans=uicontrol('parent',p_Kanal,'style','text','position',[20 600 120 20],'string','Bits transmitteed: ');
      global txt99=uicontrol('parent',p_Kanal,'style','text','position',[140 700 100 20]);
      global txt98=uicontrol('parent',p_Kanal,'style','text','position',[140 650 100 20]);
      global txt97=uicontrol('parent',p_Kanal,'style','text','position',[140 600 100 20]);
    end
  end
end

   
  
  


