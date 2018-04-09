% create figure and panel on it
f = figure;
set(gcf, 'position',[100,100,1000,800]);
%creat panels
p_Nadajnik = uipanel ("title", "Nadajnik", "position", [.0 0 .35 .95]);
p_Kanal = uipanel ("title", "Kana³", "position", [.35 0 .35 .95]);
p_Odbiornik = uipanel ("title", "Odbiornik", "position", [.70 0 .30 .95]);
% create a button group
gp = uibuttongroup (f, "Position", [ 0 0.95 1 0.2])
% create a buttons in the group
b1 = uicontrol (gp, "style", "radiobutton", ...
                "string", "Stop-and-wait", ...
                "Position", [120 15 100 15 ]);
b2 = uicontrol (gp, "style", "radiobutton", ...
                "string", "Go-Back-N", ...
                "Position", [ 480 15 100 15 ]);
b3 = uicontrol (gp, "style", "radiobutton", ...
                "string", "Selective Repeat", ...
                "Position", [ 800 15 150 15 ]);
% create a button not in the group
txt = uicontrol('parent',p_Nadajnik,'Style','text',...
        'Position',[20 710 140 20],...
        'String','Wiadomoœæ wychodz¹ca');
txt2 = uicontrol('parent',p_Odbiornik,'Style','text',...
        'Position',[20 710 140 20],...
        'String','Wiadomoœæ odebrana');
%create a checkboxs
checkbox1= uicontrol("parent",p_Kanal,"style","checkbox","string", 
           "zak³ócenie_1","position", 
           [50 600 150 100]); % 75 20 100 1100
checkbox2= uicontrol("parent",p_Kanal,"style","checkbox","string", 
           "zak³ócenie_2","position", 
           [50 450 150 100]);
checkbox3 =uicontrol("parent",p_Kanal,"style","checkbox","string","zak³ócenie_3",
           "position",[ 50 300 150 100]);
checkbox4 =uicontrol("parent",p_Kanal,"style","checkbox","string","zak³ócenie_4",
            "position",[50 150 150 100]);
%create sliders
slider1=uicontrol("parent",p_Kanal ,"Style","slider","Position",[200 600 15 100]); %'callback', {@nazwafucnkji}
slider2=uicontrol("parent",p_Kanal,'Style','slider','Position',[200 450 15 100]);
slider3=uicontrol("parent",p_Kanal,"Style","slider","Position",[200 300 15 100]);
slider4=uicontrol ("parent",p_Kanal,"Style","slider","Position", [200 150 15 100]);
%%%OUTPUT NADAJNIK
output_text=uicontrol("parent",p_Nadajnik,"style","text","position",[100 450 150 20]);
YourArray=[11 22 33];
set(output_text,"String",num2str(YourArray(1)));
%%%OUTPUT ODBIORNIK
output_text2=uicontrol("parent",p_Odbiornik,"style","text","position",[100 450 150 20]);
set(output_text2,"String",num2str(YourArray(2)));