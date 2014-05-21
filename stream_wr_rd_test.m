function stream_wr_rd_test()    
    %% write bit stream to fid test
    for i=1:1:1000
        stream = randsrc(1,i,[1 0 ;0.5 0.5]);
        fid    = fopen('write_steam2file_test','w');
            write_stream2file(stream,fid);
            fclose(fid);
        fid   = fopen('write_steam2file_test','r');
            stream_re = read_streamfile(fid);
            fclose(fid);
        res = isequal(stream_re,stream);
        if(res==0)
            fprintf('ERR write_strem/read stream len=%d stream=%d\n',i);
        end
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