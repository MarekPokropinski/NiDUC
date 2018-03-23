function vector = loadFromFile(filename)
  f=fopen(filename,'rb');
  vector=fread(f,precision="uint8");
  fclose(f);
endfunction
