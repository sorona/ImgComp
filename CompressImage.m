function [ PSNR,BPP ] = CompressImage( imgFileName,outFileName,Cpar )
%% get Image 
Im= imread(imgFileName);
% pixNum = dir(imgFileName);
pixNum = numel(Im);%TODO:review BPP comparison to what
% Im = zeros(size(Im));
% Im(100:200,100:200)=1;
% Im = Im+randn(size(Im))*10e-4;
% pixNum = numel(Im);
Imfig = figure();subplot(1,2,1);imshow(Im);title('Original Image')
   
%% Wavelet Transform
    % fixed param
    Wpar.wavelet = wavelet_name();
    dwtmode('per','nodisp')  
    Wpar.plots = Cpar.waveletPlot;
    % send param
    Wpar.level = Cpar.waveletLevel; % TODO : fixed param? review
    Wpar.S = [];   
    Wpar.header.field = {'S','level'};
    Wpar.header.type  = {'uint16','uint8'};
    % encode
    [Ap,H,V,D,Wpar] = WaveletEncode(Im,Wpar);
 % Verfication and Test  
    if(Cpar.waveTest)
         wavelet_test(Im,Wpar);
    end

%% **********Approx band path**********
% Ap->Q->Entropy
% fixed param
Apar.bins = Cpar.ApBins;

Apq = QunatizeEncodeVec(Ap,Apar); 
Apd = DiffCodeApq(Apq); 
Ape = EntropyEncodeApd(Apd);
% add test and verfication of approx band

%% ********Coefficients path***********
% Coeff->KSVD->OMP->Q->Diff->Enrtopy
%% S-KSVD  (train dictionaries)
    % fixed param
    Kpar.perTdict  = Cpar.perTdict;
    Kpar.trainPSNR = Cpar.trainPSNR;
    Kpar.R         = 4; % dictionary reduandancy
    Kpar.iternum   = Cpar.iternum;
    
    Kpar.printInfo = Cpar.KparPrintInfo;
    Kpar.plots     = Cpar.Kparplots;
    [Dict] = TrainDictCells(H,V,D,Wpar,Kpar);
% Verefication and test
%       ksvd_experiment()
%       ksvd_test(H,V,D,Wpar,Kpar);
%% OMP (obtain sparse representation)
    Kpar.gomp_test = Cpar.Kpargomp_test;
    dbstop in OMPCells
    [GAMMA] = OMPcells(H,V,D,Dict,Wpar,Kpar);

%% Quantizatie Dictionaries
% consider quantize all for same codebook (values +-1)
% fixed param
    Qpar.bins = Cpar.bins;
% send param
    DictQ = QuantizeDict(Dict,Wpar,Qpar);
    
% [Apq,Hdq,Vdq,Ddq] = QuantizeCells(Ap,Hd,Vd,Dd,Wpar,Qpar);
% Verefication and test
    %TODO: quantization of large gamma may casue problems becasue dynamic
    %range
%     save('HdSamp.mat','Hd');
%     quantization_experiment('HdSamp.mat');
%     quantization_test(Ap,Hd,Vd,Dd,Wpar,Qpar);
%% Quantizatie GAMMA

%% Difference Encoding 
[Apd,Hdd,Vdd,Ddd] = DiffCodeCells(Apq,Hdq,Vdq,Ddq,Wpar); 
% Verefication and test
%     save('HdqSamp.mat','Hdq');
%     diff_experiment('HdqSamp.mat');
%     diff_test(Apq,Hdq,Vdq,Ddq,Wpar); 
if(Cpar.diffPlots)
  diff_plots(Apd,Hdd,Vdd,Ddd,Wpar,Qpar);
end
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

    % TOOD: SSIM check here
figure(Imfig);subplot(1,2,2);imshow(Im_rec,[0 255]);title('Reconstructed Image');


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
    if(isfield(Cpar,'fileStatsPlot'))
        if(Cpar.fileStatsPlot)
            fileStats =[wSize.hedSize,wSize.parSize,wSize.strSize]; 
            labels = {sprintf('Headers\n%.2f',wSize.hedSize/file_size)...
                     ,sprintf('Param\n%.2f'  ,wSize.parSize/file_size)...
                     ,sprintf('Stream\n%.2f' ,wSize.strSize/file_size)};
            figure();pie(fileStats,labels);     
        end
    end
    
% dbstop in filewrite_test
filewrite_test(PackedParam,filename);   
% filewrite_experiment();
    
%% Performence Estimation


BPP = file_size/pixNum;
figure(Imfig);
suptitle(sprintf('Copression Results: PSNR=%.2f BPP=%.2f\n waveLevel=%d Redundancy=%d, perDict=%.4f, perEdata=%.4f bins=%d'...
                  ,PSNR,BPP,Cpar.waveletLevel...
                           ,Cpar.Redun...
                           ,Cpar.perTdict...
                           ,Cpar.perEdata...
                           ,Cpar.bins));   

end

