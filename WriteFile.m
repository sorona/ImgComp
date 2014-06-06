function [file_size,wSize] = WriteFile(PackedParam,filename)
    % unpack param
    
    wSize.hedSize = 0;
    wSize.strSize = 0;
    wSize.parSizeName = {};
    wSize.parSizeLen  = {};
    
    if(isfield(PackedParam,'test'))
            fid    = fopen(filename,'w');
            wSize = write_struct2file(fid,PackedParam ,wSize);
            wSize.parSize = computeParSize(wSize);
            wSize.tot     = wSize.parSize+wSize.hedSize+wSize.strSize;
            file_size = ftell(fid);
            fclose(fid);
            return;
    end
           
    Wpar  = PackedParam.Wpar;
    Kpar  = PackedParam.Kpar;
    Coeff = PackedParam.Coeff;
    
    fid    = fopen(filename,'w');
    wSize = write_struct2file(fid,Wpar ,wSize);
    wSize = write_struct2file(fid,Kpar ,wSize);
    wSize = write_struct2file(fid,Coeff,wSize);
    
    wSize.parSize = computeParSize(wSize);
    wSize.tot     = wSize.parSize+wSize.hedSize+wSize.strSize;
    file_size = ftell(fid);
    fclose(fid);
end
%% compute param size
function parSize = computeParSize(wSize)
    parSize = 0;
    for i=1:length(wSize.parSizeLen)
        switch wSize.parSizeName{i}
            case 'double'
                parSize = parSize +8*wSize.parSizeLen{i};
            case 'int8'
                parSize = parSize +1*wSize.parSizeLen{i};
            case 'int16'	
                parSize = parSize +2*wSize.parSizeLen{i};
            case 'int32'	
                parSize = parSize +4*wSize.parSizeLen{i};
            case 'int64'	
                parSize = parSize +8*wSize.parSizeLen{i};
            case 'uint8'	
                parSize = parSize +1*wSize.parSizeLen{i};
            case 'uint16'	
                parSize = parSize +2*wSize.parSizeLen{i};
            case 'uint32'
                parSize = parSize +4*wSize.parSizeLen{i};
            case 'uint64'
                parSize = parSize +8*wSize.parSizeLen{i};
            otherwise
                error('ERR type not supported')
        end
    end
end
%% write struct 2 file
function [wSize] = write_struct2file(fid,Spar,wSize)
    % output
    % wSize.hedSize;
    % wSize.strSize;
    % wSize.parSize;
    field   = Spar.header.field;  
    type    = Spar.header.type;
    for i=1:length(Spar.header.field)
        switch type{i}
            case 'stream'
                % writing len (2^32-1) resereved for stream
                fwrite(fid,2^32-1,'uint32');
                wSize.hedSize = wSize.hedSize + 4; % 4 byte write header
                stream        = eval(sprintf('Spar.%s;',field{i}));
                tmpSize       = write_stream2file (stream,fid);
                wSize.strSize = wSize.strSize + tmpSize;
            case 'struct'
                % writing len (2^32-2) resereved for stream
                fwrite(fid,2^32-2,'uint32');
                wSize.hedSize = wSize.hedSize + 4; % 4 byte write header
                struct        = eval(sprintf('Spar.%s;',field{i}));
                wSize         = write_struct2file(fid,struct,wSize);
            case 'cell'
                % writing len (2^32-3) reserved for cell
                fwrite(fid,2^32-3,'uint32');
                wSize.hedSize = wSize.hedSize + 4; % 4 byte write header
                cell_len = eval(sprintf('length(Spar.%s);',field{i}));
                for j=1:cell_len
                    tmp_struct = eval(sprintf('Spar.%s{%d};',field{i},j));
                    wSize      = write_struct2file(fid,tmp_struct,wSize);
                end
            otherwise %(Param vector (nx1))
                % writing len before header (implicit)
                fwrite(fid,eval(sprintf('length(Spar.%s)',field{i})),'uint32');
                wSize.hedSize = wSize.hedSize + 4; % 4 byte write header
                    % check len overflow uint32 
                    if(eval(sprintf('length(Spar.%s)',field{i}))>=2^32-3) 
                        error('ERR write_struct2file "len" overflows uint32...(also: 2^32-1 2^32-2 2^32-3 are reserved)'); 
                    end;
                % wrtiring params   
                fwrite(fid,eval(sprintf('Spar.%s',field{i})),type{i});
                wSize.parSizeName= {wSize.parSizeName{:},type{i}};
                wSize.parSizeLen = {wSize.parSizeLen{:} ,eval(sprintf('length(Spar.%s)',field{i}))};
        end
    end
end

%% wrtie stream 2 file function
function [strSize] = write_stream2file (stream,fid)
    tmp_len = length(stream);
    pad     = mod(8-mod(tmp_len,8),8);
    stream  = [stream , zeros(1,pad)];
    % sainty check
        if(mod(size(stream,2),8)~=0);fprintf('ERR Padding write file BUG\n');end
    % shape as 8 byte stream
    streamU8 = reshape(stream,[],8);
    streamU8 = bi2de(streamU8);
    len      = length(streamU8);
    fwrite(fid,len,'uint32'); %TODO Packedbits protocol style
    strSize = 4;
        if(len>=2^32)
             error('ERR write_stream2file "len" overflows uint32'); 
        end
    fwrite(fid,pad,     'uint8' );
    strSize = strSize + 1;
    fwrite(fid,streamU8,'uint8' );
    strSize = strSize + length(stream)/8;   
end

