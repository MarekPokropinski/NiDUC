channel = Channel;

channel.BSCStatus = 1;
channel.gilbertStatus = 1;

for i = 1 : 50
  disp(channel.transmit(0));
end
