function WriteFile(PackedParam,filename)
    % unpack param
    Wpar  = PackedParam.Wpar;
    Coeff = PackedParam.Coeff;
    
    fid    = fopen(filename,'w');
    write_struct2file(fid,Wpar);
    write_struct2file(fid,Coeff);
    filesize = ftell(fid)
    fclose(fid);
    
    PackedParamRe = ReadFile(filename);

end

function PackedParam = ReadFile(filename)
    fid = fopen(filename,'r');
end
%% write complex struct 
function write_struct2file(fid,Spar)
    field = Spar.header.field;  
    type  = Spar.header.type;
    for i=1:length(Spar.header.field)
        switch type{i}
            case 'stream'
                % writing len (2^32-1) resereved for stream
                fwrite(fid,2^32-1,'uint32');
                stream = eval(sprintf('Spar.%s;',field{i}));
                write_stream2file (stream,fid);
            case 'struct'
                % writing len (2^32-2) resereved for stream
                fwrite(fid,2^32-2,'uint32');
                struct = eval(sprintf('Spar.%s;',field{i}));
                write_struct2file(fid,struct);
            case 'cell'
                % writing len (2^32-3) reserved for cell
                fwrite(fid,2^32-3,'uint32');
                cell_len = eval(sprintf('length(Spar.%s);',field{i}));
                for j=1:cell_len
                    tmp_struct = eval(sprintf('Spar.%s{%d};',field{i},j));
                    write_struct2file(fid,tmp_struct);
                end
            otherwise 
                % writing len before header (implicit)
                fwrite(fid,eval(sprintf('length(Spar.%s)',field{i})),'uint32');
                    % check len overflow uint32 
                    if(eval(sprintf('length(Spar.%s)',field{i}))>=2^32-3) 
                        error('ERR write_struct2file "len" overflows uint32...(also: 2^32-1 2^32-2 2^32-3 are reserved)'); 
                    end;
                % wrtiring params   
                fwrite(fid,eval(sprintf('Spar.%s',field{i})),type{i});
        end
    end
end


%% read complex struct
function SparRe = read_structfromfile(fid,Spar)
    field_no = length(Spar.header.field);
    field = Spar.header.field;  
    type  = Spar.header.type;
    len   = cell(1,length(field));
    for i=1:field_no
        len{i} = fread(fid,1,'uint32');
        switch len{i}
            % stream
            case 2^32-1 % len that symbols stream
                stream = read_streamfile(fid);
                eval(sprintf('SparRe.%s=stream;',field{i}));
            % struct
            case 2^32-2
                InnerSpar = eval(sprintf('Spar.%s;',field{i}));
                InnerSpar = read_structfromfile(fid,InnerSpar);
                eval(sprintf('SparRe.%s=InnerSpar;',field{i}))
            % cell
            case 2^32-3
                cell_len = eval(sprintf('length(Spar.%s);',field{i}));
                tmp_cell = cell(1,cell_len);
                for j=1:cell_len
                    Inner_cell = eval(sprintf('Spar.%s{%d};',field{i},j));
                    tmp_cell{j}= read_structfromfile(fid,Inner_cell);
                end
                eval(sprintf('SparRe.%s=tmp_cell;',field{i}));
            otherwise
            eval(sprintf('SparRe.%s=fread(fid,len{%d},type{%d});',field{i},i,i)); 
        end
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
    fwrite(fid,len,'uint32');
        if(len>=2^32)
             error('ERR write_stream2file "len" overflows uint32'); 
        end
    fwrite(fid,pad,     'uint8' );
    fwrite(fid,streamU8,'uint8' );
end
 %% read bit stream from file func
function stream = read_streamfile(fid)
    len    = fread(fid,1,'uint32'); 
    pad    = fread(fid,1,'uint8');
    streamU8 = fread(fid,len,'uint8');
    stream = de2bi(streamU8,8);
    stream = reshape(stream,1,[]);
    stream = stream(1:end-pad);
end