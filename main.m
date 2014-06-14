% main.m
%% Single Test
close all;clear all;clc;
imgFileName = 'barbara.gif';
outFileName = 'barbaraComp';

% Wavelet param
Cpar.waveletLevel = 6; % TODO: review moving 5->6 level bad results
Cpar.waveletPlot  = 0;
Cpar.waveTest     = 0;
% Aprrox band param
    % Quantization  
    Cpar.ApBins = 2^8;
% KSVD param
Cpar.perTdict      = 0.15;
Cpar.iternum       = 3;
Cpar.KparPrintInfo = 1;
Cpar.Kparplots     = 0;
Cpar.Kpargomp_test = 1;
% Cpar.perTdata  = 0.5;%TODO: make KSVD prints right for this one
Cpar.perEdata  = 0.3;
Cpar.trainPSNR      = 40;
Cpar.iternum   = 1;
Cpar.ksvdPlots = 0;
% Quantization param
Cpar.bins = 2^5;
% Diff param
Cpar.Diffplots = 0;
% Arithcode param
Cpar.arith_test = 0;
% file statistics
Cpar.fileStatsPlot = 1;
dbstop in CompressImage
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
% 6. grep PSNR in folder Review (maxi=? 255?)

% TODO: PRIO 2
% 1. improve info on ksvd
% 1. add test and verification by option in main
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
