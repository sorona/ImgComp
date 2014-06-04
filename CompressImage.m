function [ PSNR,BPP ] = CompressImage( imgFileName,outFileName,Cpar )
%% get Image 
Im= imread(imgFileName);
ImSize = dir(imgFileName);
ImSize = ImSize.bytes;
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
    Wpar.S = Wpar.S(:,1); % TODO:genralize to non square images
 % Verfication and Test   
%     wavelet_test(Im,Wpar);

%% S-KSVD
    % fixed param
    Kpar.R       = 4; % redundancy of dictionary
%     par.perTdata = 0.2;
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
%     diff_test(Apq,Hdq,Vdq,Ddq,Wpar); 
%% Entropy Encoding
[Ape,Hde,Vde,Dde] = EntropyEncodeCells(Apd,Hdd,Vdd,Ddd,Wpar); 
% Verefication and test
%     save('HddSamp.mat','Hdd');
%     arithcode_experiment('HddSamp.mat',Qpar.bins);
%     arithcode_test(Apd,Hdd,Vdd,Ddd,Wpar);
  
%% PSNR SSIM Eval
[A,H,V,D] = EntropyDecodeCells(Ape,Hde,Vde,Dde,Wpar); 
[A,H,V,D] = DiffDecodeCells(A,H,V,D,Wpar); 
[A,H,V,D] = QuantizeDecodeCells(A,H,V,D,Wpar,Qpar);
    Wpar.S = [Wpar.S(:) Wpar.S(:)];
[H,V,D]   = sparseToCoef(H,V,D,Wpar,Kpar);% TODO:genralize to non square images
Im_rec    = WaveletDecode(A,H,V,D,Wpar);
    Wpar.S = Wpar.S(:,1); % TODO:genralize to non square images
    
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
    file_size = WriteFile(PackedParam,filename);
    
% save('HdeSamp.mat','Hde','Wpar');
%      filewrite_test('HdeSamp.mat');     
    
%% Performence Estimation

BPP = file_size/ImSize;
suptitle(sprintf('Copression Results: PSNR=%.2f BBP=%.2f',PSNR,BPP));   

end

