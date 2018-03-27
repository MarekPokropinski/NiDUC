function saveToFile(filename,vector)
  f = fopen(filename,"wb");
  fwrite(f,vector,precision="uint8");
  fclose(f);
endfunction
