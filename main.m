clear all;close all; clc;

%% get Image 
Im= imread('lenna.gif');

%% Wavelet Transform
level   = 3; 
wavelet_name = 'db4'; %sym8 db4
dwtmode('per')

[C,S] = wavedec2(Im,level,wavelet_name);
% figure(); showwave2( C,S,level,wavelet_name )
[Ap,H,V,D] = getCoefCel( C,S,level,wavelet_name);

%% S-KSVD 
Patch_size = 64;
[Hd,Vd,Dd] = KsvdDecomposeCells(H,V,D,level,Patch_size); % 'Ap' is kept as is
% Verefication and test
    save('HdSamp.mat','Hd');
    quantization_test('HdSamp.mat');
%% Quantization encoding
bins = 2^8; 
[Apq,Hdq,Vdq,Ddq] = QuantizeCells(Ap,Hd,Vd,Dd,level,bins);
% Verefication and test    
    save('HdqSamp.mat','Hdq');
    diff_test('HdqSamp.mat');
%% Difference Coding
[Apd,Hdd,Vdd,Ddd] = DiffCodeCells(Apq,Hdq,Vdq,Ddq,level); 
% Verefication and test
    save('HddSamp.mat','Hdd');
    arithcode_test('HddSamp.mat');
%% Entropy Encoding
[Apd,Hdd,Vdd,Ddd] = DiffCodeCells(Apq,Hdq,Vdq,Ddq,level); 
% Verefication and test
    save('HddSamp.mat','Hdd');
    arithcode_test('HddSamp.mat');
%% Write file

%% Performence Estimatino
%% Read  file

%% Decoding


%% Reconstruction
 
Arec = Ap;
[Hrec,Vrec,Drec] = sparseToCoef(Hd,Vd,Dd,level);

C_r = getWaveletStream(Arec,Hrec,Vrec,Drec);

Im_rec = waverec2(C_r,S,wavelet_name);
imshow(Im_rec,[]);




