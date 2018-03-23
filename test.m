clear;
generator = data_generator(124);
vec = getVector(generator,1024*1024);
saveToFile("dane",vec);
vec2 = loadFromFile("dane");