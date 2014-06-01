function Im_rec = WaveletDecode(Ap,H,V,D,Wpar)
    % param unpack
    level = Wpar.level;
    S     = Wpar.S;
    wavelet_name = Wpar.wavelet;
    C = getWaveletStream(Ap,H,V,D);
    Im_rec = waverec2(C,S,wavelet_name);
end