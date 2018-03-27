clear;
generator = data_generator(124);
vec = getVector(generator,9);

t = transmitter(5);
packets = createPackets(t,vec);

data = createBracket(t,packets,@get_xor);

crc = get_crc(vec);