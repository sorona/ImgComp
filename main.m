% main.m
%% Single Test
close all;clear all;clc;
imgFileName = 'barbara.gif';
outFileName = 'barbaraComp';

% Wavelet param
Cpar.waveletPlot  = 0;
Cpar.waveletLevel = 3;
% KSVD param
Cpar.Redun     = 2;
Cpar.ksvdPlots = 0;
Cpar.perTdict  = 0.01;
Cpar.perEdata  = 0.11;
Cpar.iternum   = 2;
% Quantization param
Cpar.bins = 2^4;
% file statistics
Cpar.fileStatsPlot = 1; 
[ PSNR,BPP ] = CompressImage( imgFileName,outFileName,Cpar );

%% Multi Test
imgFileName = 'barbara.gif';
outFileName = 'barbaraComp';
for wL=[6,4]
    for pT = [1,0.5,0.9]
        for eD = [0.00000001 , 0.001 , 0.01 , 0.1]
            for rD = [4,2]
                for Bin = [2^10,2^6,2^5,2^7]
                    % Wavelet param
                    Cpar.waveletPlot   = 0;
                    Cpar.waveletLevel   = wL;
                    % KSVD param
                    Cpar.Redun =rD;
                    Cpar.ksvdPlots = 1;
                    Cpar.perTdict = pT;
                    Cpar.perEdata = eD;
                    Cpar.iternum  = 30;
                    % Quantization param
                    Cpar.bins = Bin;
                    % file statistics
                    Cpar.fileStatsPlot = 0;     
                    [ PSNR,BPP ] = CompressImage( imgFileName,outFileName,Cpar );
                end
            end
        end
    end
end

