function [ PSNR,BPP ] = CompressImage( imgFileName,outFileName,Cpar )
%% get Image 
Im= imread(imgFileName);
% ImSize = dir(imgFileName);
ImSize = numel(Im);%TODO:review
% Im = zeros(size(Im));
% Im(100:200,100:200)=1;
% Im = Im+randn(size(Im))*10e-4;
% ImSize = numel(Im)*8;
Imfig = figure();subplot(1,2,1);imshow(Im);title('Original Image')
   
%% Wavelet Transform
    % fixed param
    Wpar.wavelet = wavelet_name();
    dwtmode('per','nodisp')  
    Wpar.plots = Cpar.waveletPlot;
    % send param
    Wpar.level = Cpar.waveletLevel;
    Wpar.S = [];    
    Wpar.header.field = {'S','level'};
    Wpar.header.type  = {'uint16','uint8'};
    % encode
    [Ap,H,V,D,Wpar] = WaveletEncode(Im,Wpar);
 % Verfication and Test   
%     wavelet_test(Im,Wpar);

%% S-KSVD
    % fixed param
    Kpar.R       =  Cpar.Redun; % redundancy of dictionary
%     Kpar.perTdata = 0.4;
    Kpar.perTdict = Cpar.perTdict;
    Kpar.perEdata = Cpar.perEdata;
    Kpar.iternum =  Cpar.iternum;
    Kpar.plots   =  Cpar.ksvdPlots;
    % send param
    Kpar.dictLen=[]; 
    Kpar.patchSize=[];
    Kpar.header.field = {'dictLen','patchSize'};
    Kpar.header.type  = {'uint16','uint8'};
    [Hd,Vd,Dd,Kpar] = KsvdDecomposeCells(H,V,D,Wpar,Kpar); % 'Ap' is kept as is
% Verefication and test
%       ksvd_experiment()
%       ksvd_test(H,V,D,Wpar,Kpar);
%% Quantization encoding
% fixed param
    Qpar.bins = Cpar.bins;
% send param
    % sepcific pararms send with each cell TODO: consider gathering outside
    % for optimzations
[Apq,Hdq,Vdq,Ddq] = QuantizeCells(Ap,Hd,Vd,Dd,Wpar,Qpar);
% Verefication and test
    %TODO: quantization of large gamma may casue problems becasue dynamic
    %range
%     save('HdSamp.mat','Hd');
%     quantization_experiment('HdSamp.mat');
%     quantization_test(Ap,Hd,Vd,Dd,Wpar,Qpar);
%% Difference Encoding 
[Apd,Hdd,Vdd,Ddd] = DiffCodeCells(Apq,Hdq,Vdq,Ddq,Wpar); 
% Verefication and test
%     save('HdqSamp.mat','Hdq');
%     diff_experiment('HdqSamp.mat');
      diff_test(Apq,Hdq,Vdq,Ddq,Wpar); 
      diff_plots(Apd,Hdd,Vdd,Ddd,Wpar,Qpar);
%% Entropy Encoding
[Ape,Hde,Vde,Dde] = EntropyEncodeCells(Apd,Hdd,Vdd,Ddd,Wpar); 
% Verefication and test
%     save('HddSamp.mat','Hdd');
%     arithcode_experiment('HddSamp.mat',Qpar.bins);
    if(isfield(Cpar,'arith_test'))
        if(Cpar.arith_test)
            arithcode_test(Apd,Hdd,Vdd,Ddd,Wpar,Qpar);
        end
    end
%% PSNR SSIM Eval
[A,H,V,D] = EntropyDecodeCells(Ape,Hde,Vde,Dde,Wpar); 
[A,H,V,D] = DiffDecodeCells(A,H,V,D,Wpar); 
[A,H,V,D] = QuantizeDecodeCells(A,H,V,D,Wpar,Qpar);
[H,V,D]   = sparseToCoef(H,V,D,Wpar,Kpar);
Im_rec    = WaveletDecode(A,H,V,D,Wpar);
    Wpar.S = Wpar.S(:); % TODO:genralize to non square images
    
    Im   = double(Im);
    MSE  = (norm(Im-Im_rec,'fro'))^2/numel(Im);
    MAXI = 255;%TODO: review
    PSNR = 10*log10(MAXI^2/MSE);
    
figure(Imfig);subplot(1,2,2);imshow(Im_rec,[]);title('Reconstructed Image');

%% TODO: reconstruc here without file writing compute 
%% PSNR SSIM check that after read is the same
%% DO write test use isequal

%% Write file
    
    Coeff.Ape=Ape;
    Coeff.Hde=Hde;
    Coeff.Dde=Dde; 
    Coeff.Vde=Vde;
    Coeff.header.field = {'Ape','Hde','Dde','Vde'};
    Coeff.header.type  = {'struct','cell','cell','cell'};
    PackedParam.Coeff = Coeff;
    PackedParam.Wpar  = Wpar; 
    PackedParam.Kpar  = Kpar;
    filename = outFileName;
    [file_size,wSize] = WriteFile(PackedParam,filename);
    if(wSize.tot~=file_size)
        error('Error in estimating file size');
    end
    if(Cpar.fileStatsPlot)
        fileStats =[wSize.hedSize,wSize.parSize,wSize.strSize]; 
        labels = {sprintf('Headers\n%.2f',wSize.hedSize/file_size)...
                 ,sprintf('Param\n%.2f'  ,wSize.parSize/file_size)...
                 ,sprintf('Stream\n%.2f' ,wSize.strSize/file_size)};
        figure();pie(fileStats,labels);     
    end
    
% dbstop in filewrite_test
filewrite_test(PackedParam,filename);   
% filewrite_experiment();
    
%% Performence Estimation


BPP = file_size/ImSize;
figure(Imfig);
suptitle(sprintf('Copression Results: PSNR=%.2f BPP=%.2f\n waveLevel=%d Redundancy=%d, perDict=%.4f, perEdata=%.4f bins=%d'...
                  ,PSNR,BPP,Cpar.waveletLevel...
                           ,Cpar.Redun...
                           ,Cpar.perTdict...
                           ,Cpar.perEdata...
                           ,Cpar.bins));   

end

