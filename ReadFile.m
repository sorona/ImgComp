function PackedParam = ReadFile(filename)
    fid = fopen(filename,'r');
    
    Wpar.header.field = {'level','wavelet_num'};
    Wpar.header.type  = {'uint8','uint8'};
    Wpar = read_structfromfile(fid,Wpar);
    
    Qpar.header.field = {'OriginalSize','DC','Max'};
    Qpar.header.type  = {'uint16','double','double'};
    Epar.header.field = {'counts','trans','len'}; 
    Epar.header.type  = {'uint32','int64','uint32'};
    Dpar.header.field={'start_index'};
    Dpar.header.type ={'uint64'};

    base_struct.Qpar = Qpar;
    base_struct.Epar = Epar;
    base_struct.Dpar = Dpar;
    base_struct.header.field   = {'Ecode','Epar','Qpar','Dpar'};
    base_struct.header.type  = {'stream','struct','struct','struct'};
    
    Coeff.header.field = {'Ape','Hde','Dde','Vde'};
    Coeff.header.type  = {'struct','cell','cell','cell'};
    Coeff.Ape = base_struct;
    for i=2:4
        for j=1:Wpar.level
            A     = base_struct;
            GAMMA = base_struct;
            Outer.A = A;
            Outer.GAMMA = GAMMA;
            Outer.header.field = {'GAMMA','A'};
            Outer.header.type  = {'struct','struct'};
            eval(sprintf('Coeff.%s{%d}=Outer;',Coeff.header.field{i},j));
        end
    end
    
    Coeff = read_structfromfile(fid,Coeff);
    PackedParam.Wpar = Wpar;
    PackedParam.Coeff = Coeff;
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


 %% read bit stream from file func
function stream = read_streamfile(fid)
    len    = fread(fid,1,'uint32'); 
    pad    = fread(fid,1,'uint8');
    streamU8 = fread(fid,len,'uint8');
    stream = de2bi(streamU8,8);
    stream = reshape(stream,1,[]);
    stream = stream(1:end-pad);
end