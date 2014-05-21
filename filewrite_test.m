function filewrite_test(file_name)
    load(file_name)
    test_file_name = 'test_write';

    stream = [ 1 0 1 0 1 1 1 1 0 0 0 0 1];
    len    = length(stream);
    pad    = len-floor(len)/8;
    stream = [stream , zeros(1,pad)];
    
%     pad    = 
    
%     Hde  
%     Wpar 
    H    = Hde{1}.GAMMA;
    Qpar = H.Qpar;
    
    Gamma.header.fields      = {'Ecode'};
    Gamma.header.type        = {'stream'};
    Gamma.header.len         = {-1};
    Gamma.Ecode.stream       = [1 0 1 0 1 0];
    Gamaa.Ecode.len          = length(Gamma.Ecode.stream.stream); 
    Gamma.Ecode.pad          = 
%     Gamma.Qpar.OriginalSize = [64 1024];
%     Gamam.Qpar.DC           = 1232.4422;
    
    % write
    fid =fopen(test_file_name,'w');
%     fwrite(fid,Wpar.level,'uint8');
    
%     fwrite(fid,H.Qpar.OriginalSize,'uint32');
%     fwrite(fid,H.Qpar.DC,'double');
%     fwrite(fid,H.Qpar.Max,'double');
    
    filesize = ftell(fid);
    
    fclose(fid);
    % file size    
    fprintf('write_test file size %d Bytes\n',filesize);
   
    % read
    fid   = fopen(test_file_name,'r');
%     level = fread(fid,1,'uint8'); isequal(level,Wpar.level)
%     OriginalSize = fread(fid,size(Qpar.OriginalSize),'uint32'); isequal(OriginalSize,Qpar.OriginalSize)
    
    
    fclose(fid);
end