% main.m
%% Single Test
imgFileName = 'barbara.gif';
outFileName = 'barbaraComp';

% Wavelet param
Cpar.waveletPlot  = 0;
Cpar.waveletLevel = 5;
% KSVD param
Cpar.Redun     = 4;
Cpar.ksvdPlots = 0;
Cpar.perTdict  = 0.1;
Cpar.perEdata  = 0.3;
Cpar.iternum   = 20;
% Quantization param
Cpar.bins = 2^12;
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
                    [ PSNR,BPP ] = CompressImage( imgFileName,outFileName,Cpar );
                end
            end
        end
    end
end

