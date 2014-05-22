function filewrite_test(file_name)
    w = load(file_name);

    test_file_name = 'test_write';

    
    Spar.counts = [1;2;21 ];                        % vector (must be nx1)
    Spar.len    = 213212;                           % number
%     Spar.stream = randsrc(1,126,[1 0 ;0.5 0.5]);    % bit stream
    Spar.lewew  = [321; 213 ; 123221];              % vector (must be nx1)
%     Spar.bad    = zeros(2^16+1,1);                  % to much long vector of parameters
    Spar.header.field = {'counts','len','lewew'};
    Spar.header.type  = {'uint16','uint32','uint32'};
    
    fid    = fopen('test_write','w');
    write_struct2file(fid,Spar);
    filesize = ftell(fid)
    fclose(fid);
    
    Spar2.header.field = Spar.header.field; 
    Spar2.header.type  = Spar.header.type;
%     Spar2.header.len   = cell(1,length(Spar.header.field));
    
    fid   = fopen('test_write','r');
    Spar2 = read_structfromfile(fid,Spar2);
    filesize = ftell(fid)
    fclose(fid);
    Spar2
    Spar
    
    % write struct parameters fucntion
    function write_struct2file(fid,Spar)
        field = Spar.header.field;  
        type  = Spar.header.type;
        for i=1:length(Spar.header.field)
            fwrite(fid,eval(sprintf('length(Spar.%s)',field{i})),'uint16');
                % make sure len is not overflowing uint16
                if(eval(sprintf('length(Spar.%s)',field{i}))>2^16) 
                    error('ERR write_struct2file "len" overflows uint16'); 
                    printf('dsadsa');
                end;
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
        SparRe.header.type  = type;
    end

    %% wrtie stream 2 file function
    function write_stream2file (stream,fid)
        tmp_len = length(stream);
        pad     = mod(8-mod(tmp_len,8),8);
        stream  = [stream , zeros(1,pad)];
        % sainty check
            if(mod(size(stream,2),8)~=0);fprintf('ERR Padding write file BUG\n');end
        streamU8 = reshape(stream,[],8);
        streamU8 = bi2de(streamU8);
        len      = length(streamU8);
        fwrite(fid,len,     'uint16'); 
        fwrite(fid,pad,     'uint8' );
        fwrite(fid,streamU8,'uint8' );
    end
     %% read bit stream from file func
    function stream = read_streamfile(fid)
        len    = fread(fid,1,'uint16'); 
        pad    = fread(fid,1,'uint8');
        streamU8 = fread(fid,len,'uint8');
        stream = de2bi(streamU8,8);
        stream = reshape(stream,1,[]);
        stream = stream(1:end-pad);
    end

    
end