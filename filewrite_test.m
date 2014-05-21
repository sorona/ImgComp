function filewrite_test(file_name)
    w = load(file_name);

    test_file_name = 'test_write';
    
    
    Spar.counts = [1 2 21 ];
    Spar.len    = 213212;
    Spar.header.field = {'counts','len'};
    Spar.header.len   = {length(Spar.counts),length(Spar.len)};
    Spar.header.type  = {'uint16','uint16'};
    
    fid    = fopen('test_write','w');
    % write struct parameters 
    field = Spar.header.field;  
    len   = Spar.header.len;
    type  = Spar.header.type;
    for i=1:length(Spar.header.field)
        fwrite(fid,len{i},'uint16');
        fwrite(fid,eval(sprintf('Spar.%s',field{i})),type{i});
    end
    filesize = ftell(fid)
    fclose(fid);
    
    Spar2.header.field = Spar2.header.field; 
    % read struct
    fid   = fopen('test_write','r');
    for i=1:length(Spar.header.field)
        Spar.headerlenfread(fid,len{i},'uint16');
        fwrite(fid,eval(sprintf('Spar.%s',field{i})),type{i});
    end
    pad    = fread(fid,1,'uint8');
    
end