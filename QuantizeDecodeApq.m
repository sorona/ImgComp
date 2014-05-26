function Ap = QuantizeDecodeApq(Apq,bins)
    OriginalSize   = Apq.Qpar.OriginalSize; 
    DC             = Apq.Qpar.DC;
    Max            = Apq.Qpar.Max;
    index          = Apq.Qindex;
    
    codebook = (-bins/2:1:bins/2-1);
    quant    = (codebook(index+1));
    Apvec = quant/(bins/2)*Max+DC;
    Ap    = vec2GAMMA(Apvec,OriginalSize); %TODO different for Ap coeff
    
end