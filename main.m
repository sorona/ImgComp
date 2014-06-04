
imgFileName = 'barbara.gif';
outFileName = 'barbaraComp';
% Wavelet param
Cpar.waveletPlot   = 0;
Cpar.waveletLevel  = 4;
% KSVD param
Cpar.ksvdPlots = 0;
Cpar.perTdict = 0.8;
Cpar.perEdata = 0.001;
Cpar.iternum  = 20;
% Quantization param
Cpar.bins = 2^6;

[ PSNR,BPP ] = CompressImage( imgFileName,outFileName,Cpar );