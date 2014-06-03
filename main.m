clear all;close all; clc;
%% get Image 
Im= imread('lenna.gif');
ImSize = dir('lenna.gif');
ImSize = ImSize.bytes;

% Im = zeros(size(Im));
% Im(100:200,100:200)=1;
figure();imshow(Im);title('Original Image')
   
%% Wavelet Transform
    % fixed param
    Wpar.wavelet = wavelet_name();
    dwtmode('per','nodisp')  
    % send param
    Wpar.level = 3;
    Wpar.S = [];    
    Wpar.header.field = {'S','level'};
    Wpar.header.type  = {'uint16','uint8'};
    % encode
    [Ap,H,V,D,Wpar] = WaveletEncode(Im,Wpar);
 % Verfication and Test   
    wavelet_test(Im,Wpar);

%% S-KSVD
    % fixed param
    Kpar.R       = 2; % redundancy of dictionary
    Kpar.iternum = 1;
    Kpar.plots   = 1;
    % send param
    Kpar.dictLen=[]; 
    Kpar.patchSize=[];
    [Hd,Vd,Dd,Kpar] = KsvdDecomposeCells(H,V,D,Wpar,Kpar); % 'Ap' is kept as is
% Verefication and test
%       ksvd_experiment()
%       ksvd_test(H,V,D,Wpar,Kpar);
%% Quantization encoding
% fixed param
    Qpar.bins = 2^8;
% send param
    % sepcific pararms send with each cell TODO: consider gathering outside
    % for optimzations
[Apq,Hdq,Vdq,Ddq] = QuantizeCells(Ap,Hd,Vd,Dd,Wpar,Qpar);
% Verefication and test
    %TODO: quantization of large gamma may casue problems becasue dynamic
    %range
%     save('HdSamp.mat','Hd');
%     quantization_experiment('HdSamp.mat');
    quantization_test(Ap,Hd,Vd,Dd,Wpar,Qpar);
%% Difference Encoding 
[Apd,Hdd,Vdd,Ddd] = DiffCodeCells(Apq,Hdq,Vdq,Ddq,Wpar); 
% Verefication and test
    save('HdqSamp.mat','Hdq');
    diff_experiment('HdqSamp.mat');
    diff_test(Apq,Hdq,Vdq,Ddq,Wpar); 
%% Entropy Encoding
[Ape,Hde,Vde,Dde] = EntropyEncodeCells(Apd,Hdd,Vdd,Ddd,Wpar); 
% Verefication and test
    save('HddSamp.mat','Hdd');
    arithcode_experiment('HddSamp.mat',Qpar.bins);
    arithcode_test(Apd,Hdd,Vdd,Ddd,Wpar);
%%
save('HdeSamp.mat','Hde','Wpar');
     filewrite_test('HdeSamp.mat');    
%% Write file
    
    Coeff.Ape=Ape;
    Coeff.Hde=Hde;
    Coeff.Dde=Dde; 
    Coeff.Vde=Vde;
    Coeff.header.field = {'Ape','Hde','Dde','Vde'};
    Coeff.header.type  = {'struct','cell','cell','cell'};
    PackedParam.Coeff = Coeff;
    PackedParam.Wpar  = Wpar; 
    filename = 'CompImg';
    file_size = WriteFile(PackedParam,filename);

%% Performence Estimation

%% Read  file
    clear all; %TODO: remove
    bins = 2^8; % TODO: remove
    S = [64 64;64 64;128 128;256 256;512 512]; % TOOD remove
    filename = 'CompImg'; 
    PackedParamR = ReadFile(filename); 
    WparR        = PackedParamR.Wpar;
    CoeffR       = PackedParamR.Coeff;
    Ape = CoeffR.Ape;
    Hde = CoeffR.Hde;
    Dde = CoeffR.Dde; 
    Vde = CoeffR.Vde;
    
    level = WparR.level;
    wavelet_num = WparR.wavelet_num;
%% Entropy Decoding
[Apd,Hdd,Vdd,Ddd] = EntropyDecodeCells(Ape,Hde,Vde,Dde,level); 
    
%% Difference Decoding
[Apq,Hdq,Vdq,Ddq] = DiffDecodeCells(Apd,Hdd,Vdd,Ddd,level); 

%% Quantization Decoding
[Ap,Hd,Vd,Dd] = QuantizeDecodeCells(Apq,Hdq,Vdq,Ddq,level,bins);

%% KSVD Decoding

%% Wavelet Reconstruction
    % fixed param
    Wpar.wavelet = wavelet_name();
    dwtmode('per','nodisp')  
    % decode
    Im_rec = WaveletDecode(Ap,Hd,Vd,Dd,Wpar);
    figure();imshow(Im_rec,[]);




