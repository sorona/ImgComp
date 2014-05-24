clear all;close all; clc;

%% get Image 
Im= imread('lenna.gif');

%% Wavelet Transform
    level   = 3; 
    wavelet_cell = {'db4','sym8'};
    wavelet_num  = 1;
    wavelet_name = wavelet_cell{wavelet_num};
    dwtmode('per') 
[C,S] = wavedec2(Im,level,wavelet_name);
    % Pack Wavelet param
    Wpar.level = level;
    Wpar.wavelet_num = wavelet_num;
    Wpar.header.field = {'level','wavelet_num'};
    Wpar.header.type  = {'uint8','uint8'};
% figure(); showwave2( C,S,level,wavelet_name )
[Ap,H,V,D] = getCoefCel( C,S,level,wavelet_name);

%% S-KSVD 
Patch_size = 64;
[Hd,Vd,Dd] = KsvdDecomposeCells(H,V,D,level,Patch_size); % 'Ap' is kept as is
% Verefication and test
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
    arithcode_test('HddSamp.mat');
%% Entropy Encoding
[Ape,Hde,Vde,Dde] = EntropyEncodeCells(Apd,Hdd,Vdd,Ddd,level); 
% Verefication and test
    save('HdeSamp.mat','Hde','Wpar');
     filewrite_test('HdeSamp.mat');    
%% Write file
%     Coeff.Ape=Ape;
    Coeff.Hde=Hde;
    Coeff.Dde=Dde; 
    Coeff.Vde=Vde;
    Coeff.header.field = {'Hde','Dde','Vde'};
    Coeff.header.type  = {'cell','cell','cell'};
    PackedParam.Coeff = Coeff;
    PackedParam.Wpar  = Wpar; 
    filename = 'CompImg';
    file_size = WriteFile(PackedParam,filename);

%% Performence Estimation

%% Read  file
%     clear all; %TODO: remove
    filename = 'CompImg'; 
    PackedParamR = ReadFile(filename); 
    WparR        = PackedParamR.Wpar;
    CoeffR       = PackedParamR.Coeff;
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
% bins  = % TODO (move write and read from file)
[Ap,Hd,Vd,Dd] = QuantizeDecodeCells(Apq,Hdq,Vdq,Ddq,level,bins);

%% Wavelet Reconstruction
 
Arec = Ap;
[Hrec,Vrec,Drec] = sparseToCoef(Hd,Vd,Dd,level);

C_r = getWaveletStream(Arec,Hrec,Vrec,Drec);
wavelet_cell = {'db4','sym8'};
wavelet_name = wavelet_cell{wavelet_num};
Im_rec = waverec2(C_r,S,wavelet_name);
figure();imshow(Im_rec,[]);




