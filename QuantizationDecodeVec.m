function  ARe  = QuantizationDecodeVec(A,bins)
    % Quantization Decode A
    OriginalSize   = A.Qpar.OriginalSize; 
    DC             = A.Qpar.DC;
    Max            = A.Qpar.Max;
    index          = A.Qindex;
    
    codebook = (-bins/2:1:bins/2-1);
    quant    = (codebook(index+1));
    Avec     = quant/(bins/2)*Max+DC;
    ARe      = vec2GAMMA(Avec,OriginalSize);
end