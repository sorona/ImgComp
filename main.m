clear all;close all; clc;
%% get Image 
Im= imread('lenna.gif');
ImSize = dir('lenna.gif');
ImSize = ImSize.bytes;

% Im = zeros(size(Im));
% Im(100:200,100:200)=1;
figure();imshow(Im)
   
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
    [Ap,H,V,D] = WaveletEncode(Im,Wpar);
 % Verfication and Test   
    wavelet_test(Im,Wpar);

%% S-KSVD
    % fixed param
    Patch_size = 64;
    Kpar.Edata = 1;
    % send param
    [Hd,Vd,Dd] = KsvdDecomposeCells(H,V,D,Wpar,Kpar,Patch_size); % 'Ap' is kept as is
% Verefication and test
%   ksvd_experiment()
    ksvd_test(H,V,D,Wpar,Kpar,Patch_size);
%%      
    save('HdSamp.mat','Hd');
    quantization_test('HdSamp.mat');
%% Quantization encoding
bins = 2^8; % TODO-> convert to Qbits in all functions?
[Apq,Hdq,Vdq,Ddq] = QuantizeCells(Ap,Hd,Vd,Dd,level,bins);
% Verefication and test    
    save('HdqSamp.mat','Hdq');
    diff_test('HdqSamp.mat');
%% Difference Encoding
[Apd,Hdd,Vdd,Ddd] = DiffCodeCells(Apq,Hdq,Vdq,Ddq,level); 
% Verefication and test
    save('HddSamp.mat','Hdd');
    arithcode_test('HddSamp.mat',bins);
%% Entropy Encoding
[Ape,Hde,Vde,Dde] = EntropyEncodeCells(Apd,Hdd,Vdd,Ddd,level); 
% Verefication and test
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




