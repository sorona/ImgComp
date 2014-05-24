function [A , GAMMA]=QuantizeDecodeCell(Cq,bins)
    % Quantization Decode GAMMA
    OriginalSize   = Cq.GAMMA.Qpar.OriginalSize; 
    DC             = Cq.GAMMA.Qpar.DC;
    Max            = Cq.GAMMA.Qpar.Max;
    index          = Cq.GAMMA.Qindex;
    
    codebook = (-bins/2:1:bins/2-1);
    quant    = (codebook(index+1));
    GAMMAvec = quant/(bins/2)*Max+DC;
    GAMMA    = vec2GAMMA(GAMMAvec,OriginalSize);
    
    % Quantization Decode A
    OriginalSize   = Cq.A.Qpar.OriginalSize; 
    DC             = Cq.A.Qpar.DC;
    Max            = Cq.A.Qpar.Max;
    index          = Cq.A.Qindex;
    
    codebook = (-bins/2:1:bins/2-1);
    quant    = (codebook(index+1));
    Avec     = quant/(bins/2)*Max+DC;
    A        = vec2GAMMA(Avec,OriginalSize);
end