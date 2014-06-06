function filewrite_test(PackedParam,filename)
    filename = [filename,'_test'];
    [file_size,wSize] = WriteFile(PackedParam,filename);
    PackedParamRe = ReadFile(filename);
   % TODO: complete filewrite test 
end
