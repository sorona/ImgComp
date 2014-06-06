function filewrite_experiment()
    %% test for size calculations
    fprintf('*******File Write Experiment*******\n')
    % initial a struct
    Spar.counts = [1;2;3];  
    Spar.len    = 213212; 
    Spar.stream = randsrc(1,12,[1 0 ;0.5 0.5]); 
    Spar.header.field  = {'counts','len','stream'};
    Spar.header.type    ={'uint16','uint32','stream'};
    Spar.test = 1;
    [file_size,wSize] = WriteFile(Spar,'test_write');
    fprintf('calcuate file size=%d, eval=%d\n',file_size,wSize.tot)
    
    %%
    
%     Spar.counts = [1;2;21 ];                        % vector (must be nx1)
%     Spar.len    = 213212;                           % number
%     Spar.stream = randsrc(1,12,[1 0 ;0.5 0.5]);    % bit stream
%     Spar.strct.header.field  = {'Innercount','InnerNo'};
%     Spar.strct.header.type    = {'uint16','uint16'};
%     Spar.strct.Innercount = [12 ; 23 ; 123];
%     Spar.strct.InnerNo    = 2;
%     Spar.lewew  = [321; 213 ; 123221];              % vector (must be nx1)
%     H1=Spar.strct;
%     H2=Spar.strct;
%     Spar.cel2    = {H1,H2};
% %     Spar.bad    = zeros(2^32,1);                  % to much long vector of parameters
%     Spar.bad      = zeros(2^10-3,1);                  
%     Spar.header.field = {'counts','len','lewew','stream','strct','cel2','bad'};
%     Spar.header.type  = {'uint16','uint32','uint32','stream','struct','cell','uint16'};
%     Spar.test=1;
%     
%     file_size = WriteFile(Spar,'test_write');
%         
%     Spar2.header = Spar.header; 
%     Spar2.cel2{1}.header = Spar.cel2{1}.header;
%     Spar2.cel2{2}.header = Spar.cel2{2}.header;
%     Spar2.strct.header  = Spar.strct.header;
%     
%     fid   = fopen('test_write','r');
%     Spar2 = read_structfromfile(fid,Spar2);
% %     filesize = ftell(fid)
%     fclose(fid);
% %     Spar2;
%     Spar;
 end