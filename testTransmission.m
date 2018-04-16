clear all;

addpath("Transmitter");
addpath("Channel");
addpath("@Receiver");

generator = DataGenerator();

packet_size = 4;
dataSize = 24;

transmitter = Transmitter(packet_size,"xor");
channel = Channel();
channel.BSCStatus=1;
channel.setGilbertGoodProb(0.1);
receiver = Receiver(packet_size,"par");

data = generator.getVector(dataSize);
recvData = [];
ackVec=[];
bits = 0;

packets = transmitter.prepareData(data);
ack=0;
i=1;

while bits<dataSize
  
  o = transmitter.sendPacketSW(packets,ack);
  %transpose(o)
  o = channel.transmit(o);
  %transpose(o)

  recvData(i,1:length(o))=o;
  ack=receiver.sw(o,length(o)-1,1);
  ackVec(length(ackVec)+1)=ack;
  if ack==1
    bits+=packet_size;
  end
  i++;
end

printf("pakiety na wejsciu:\n");
display(transpose(packets));
printf("pakiety na wyjsciu:\n");
display(recvData);
printf("ack:\n");
display(transpose(ackVec));
