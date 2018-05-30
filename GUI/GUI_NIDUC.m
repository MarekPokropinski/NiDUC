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
      global p_Nadajnik = uipanel ("title", "Nadajnik", "position", [.0 0 .35 .95]);
      global p_Kanal = uipanel ("title", "Kanal", "position", [.35 0 .35 .95]);
      global p_Odbiornik = uipanel ("title", "Odbiornik", "position", [.70 0 .30 .95]);
      % create a button group
      gp = uibuttongroup (f, "Position", [ 0 0.95 1 0.2])
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
      % create a button not in the group
      txt = uicontrol('parent',p_Nadajnik,'Style','text',...
              'Position',[20 710 140 20],...
              'String','Wiadomosc wychodzaca');
      txt2 = uicontrol('parent',p_Odbiornik,'Style','text',...
              'Position',[20 710 140 20],...
              'String','Wiadomosc odebrana',"backgroundcolor",[0.8 0.2 0.3]); %%KOLOR
      text=uicontrol("parent",p_Odbiornik,"style","text","string","ACK:","position",[200 670 150 20]);
      %%global checkbox1= uicontrol("parent",p_Kanal,"value",1,"style","checkbox","string", 
         %%        "BSC probability","position", 
         %%        [50 600 150 100]); % 75 20 100 1100
     %% global checkbox2= uicontrol("parent",p_Kanal,"value",0,"style","checkbox","string", 
       %%          "Zaklocenie 2","position", 
         %%        [50 450 150 100]);
     %% checkbox3 =uicontrol("parent",p_Kanal,"style","checkbox","string","Zaklocenie 3",
      %%           "position",[ 50 300 150 100]);
    %%  checkbox4 =uicontrol("parent",p_Kanal,"style","checkbox","string","Zaklocenie 4",
      %%            "position",[50 150 150 100]);
       gDane =uicontrol("parent",p_Nadajnik,"style","pushbutton","string","generuj Dane","callback",{@callbacks,2},
                "position",[50 100 100 100]);
      symDane =uicontrol("parent",p_Nadajnik,"style","pushbutton","string","Symulacja","callback",{@callbacks,3},
                  "position",[150 100 100 100]);
     %% checkbox1_value=get(checkbox1,'value');
     %% checkbox2_value=get(checkbox2,'value');
       %create sliders
      slider1=uicontrol("parent",p_Kanal ,"Style","slider","min",0,"max",0.9,"value",0,"callback",{@callbacks,0},"Position",[30 600 300 15]); %'callback', {@nazwafucnkji}
      slider2=uicontrol("parent",p_Kanal,'Style','slider',"min",0,"max",0.9,"value",0,"callback",{@callbacks,1},'Position',[30 450 300 15]);
      slider3=uicontrol("parent",p_Kanal,"Style","slider","min",0,"max",0.9,"value",0.5,"Position",[30 300 300 15]);
      slider4=uicontrol ("parent",p_Kanal,"Style","slider","min",0,"max",0.9,"value",0.7,"Position", [30 150 300 15]);
      %%%OUTPUT NADAJNIK
      txt_I=uicontrol('parent',p_Nadajnik,'style','text','position',[20 60 100 20],'string','ilosc pakietow:');
      txt_P=uicontrol('parent',p_Nadajnik,'style','text','position',[20 30 100 20],'string','dlugosc pakietu');
      txt_ilosc=uicontrol('parent',p_Nadajnik,"style",'edit',"Position", [130 60 50 20],'callback',{@callbacks,7});
      txt_pakiety=uicontrol('parent',p_Nadajnik,'style','edit','Position',[130 30 50 20],'callback',{@callbacks,8});
      %%%OUTPUT ODBIORNIK
    end
  end
end

   
  



  


