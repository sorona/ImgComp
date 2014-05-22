function filewrite_test(file_name)
    w = load(file_name);

    test_file_name = 'test_write';
    
    
    Spar.counts = [1;2;21 ];
    Spar.len    = 213212;
    Spar.lewew  = [321; 213 ; 123221];
    Spar.header.field = {'counts','len','lewew'};
    Spar.header.len   = {length(Spar.counts),length(Spar.len),length(Spar.lewew)};
    Spar.header.type  = {'uint16','uint32','uint16'};
    
    fid    = fopen('test_write','w');
    write_struct2file(fid,Spar);
    filesize = ftell(fid)
    fclose(fid);
    
    Spar2.header.field = Spar.header.field; 
    Spar2.header.type  = Spar.header.type;
    Spar2.header.len   = cell(1,length(Spar.header.field));
    
    fid   = fopen('test_write','r');
    Spar2 = read_structfromfile(fid,Spar2);
    filesize = ftell(fid)
    fclose(fid);
    Spar2
    Spar
    
    % write struct parameters fucntion
    function write_struct2file(fid,Spar)
        field = Spar.header.field;  
        len   = Spar.header.len;
        type  = Spar.header.type;
        for i=1:length(Spar.header.field)
            fwrite(fid,len{i},'uint16');
            fwrite(fid,eval(sprintf('Spar.%s',field{i})),type{i});
        end
    end

    
    % read struct
    function SparRe = read_structfromfile(fid,Spar)
        field_no = length(Spar.header.field);
        field = Spar.header.field;  
        type  = Spar.header.type;
        len   = cell(1,length(field));
        for i=1:field_no
            len{i} = fread(fid,1,'uint16');
            eval(sprintf('SparRe.%s=fread(fid,len{%d},type{%d});',field{i},i,i)); 
        end
        SparRe.header.field = field;
        SparRe.header.len   = len;
        SparRe.header.type  = type;
    end
    
end