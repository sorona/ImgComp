function [Ap,H,V,D,WparR] = WaveletEncode(Im,Wpar)
    % param unpack
    wavelet_name = Wpar.wavelet;
    level        = Wpar.level;
    % wavelet encode 
    [C,S] = wavedec2(Im,level,wavelet_name);
    if(Wpar.plots)
        figure(); showwave2( C,S,level,wavelet_name )
    end
    [Ap,H,V,D] = getCoefCel( C,S,level,wavelet_name);
    WparR = Wpar;
    WparR.S = S;
end