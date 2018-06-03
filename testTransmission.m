clear all;

addpath("Transmitter");
addpath("Channel");
addpath("@Receiver");
addpath("GUI");
addpath("Controller");



global mode = 'sw';
global chsum='par';
global dataSize_str='0';
global packetSize='1';

global bsc_prob='0';
global gilbert_good='0';
global gilbert_bad='0';


global generator = DataGenerator();

global packet_size = 20;
global dataSize = 2000;

global transmitter = Transmitter(packet_size,mode);
global channel = Channel();
channel.BSCStatus=1;
channel.gilbertStatus=0;
channel.setBSCProb(0.1);

global receiver = Receiver(packet_size,chsum);
global gui=GUI_NIDUC(transmitter,channel,receiver);

#c = Controller();
#c.send(mode);
