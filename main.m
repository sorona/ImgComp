% main.m
%% Single Test
close all;clear all;clc;
imgFileName = 'barbara.gif';
outFileName = 'barbaraComp';

% Wavelet param
Cpar.waveletPlot  = 1;
Cpar.waveletLevel = 7; % TODO: review moving 5->6 level bad results
% KSVD param
Cpar.Redun     = 2;
Cpar.perTdict  = 0.15;
% Cpar.perTdata  = 0.5;%TODO: make KSVD prints right for this one
Cpar.perEdata  = 0.3;
Cpar.iternum   = 15;
Cpar.ksvdPlots = 0;
% Quantization param
Cpar.bins = 2^5;
% Diff param
Cpar.Diffplots = 0;
% Arithcode param
Cpar.arith_test = 0;
% file statistics
Cpar.fileStatsPlot = 1;
[ PSNR,BPP ] = CompressImage( imgFileName,outFileName,Cpar );

% TODO PRIO 1:
% 1. seperate coeff from stream (later do several option with chioce
% 2. reduce codebook like inbal work 3.4
% 2. fix patch size 8 for big 4 for small fix Reduancdancy get more patches
% if needed and and omp later
% 2. diff code to loactions after extracting from gamma / A
% 2. entropy code all GAMMA and A together -> same code book and
% translations
% 3. move omp to global omp
% 4. KSVD par PSNR
% 5. KSVD perTdict 0.15 

% TODO: PRIO 2
% 1. improve info on ksvd
% 2. add report to pdf on run
% 3. move to high res lenna/barabra
    


%% Multi Test
% imgFileName = 'barbara.gif';
% outFileName = 'barbaraComp';
% for wL=[6,4]
%     for pT = [1,0.5,0.9]
%         for eD = [0.00000001 , 0.001 , 0.01 , 0.1]
%             for rD = [4,2]
%                 for Bin = [2^10,2^6,2^5,2^7]
%                     % Wavelet param
%                     Cpar.waveletPlot   = 0;
%                     Cpar.waveletLevel   = wL;
%                     % KSVD param
%                     Cpar.Redun =rD;
%                     Cpar.ksvdPlots = 1;
%                     Cpar.perTdict = pT;
%                     Cpar.perEdata = eD;
%                     Cpar.iternum  = 30;
%                     % Quantization param
%                     Cpar.bins = Bin;
%                     % file statistics
%                     Cpar.fileStatsPlot = 0;     
%                     [ PSNR,BPP ] = CompressImage( imgFileName,outFileName,Cpar );
%                 end
%             end
%         end
%     end
% end
% 
