addpath('channel');

gec = GEChannel;

vec = [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0];

out = gec.transmit(vec);