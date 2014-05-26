function Apq = QuantizeAp(Ap,bins)
    % Quantize encode Ap coeff
    OriginalSize = size(Ap); 
    Apvec = Gamma2vec(Ap);
    Apvec = Apvec';
    DC     = mean(Apvec);
    Apvec = Apvec-DC;
    Max    = max(abs(Apvec));
    % encode
    partition = ((-bins/2:1:bins/2-2)+0.5)/(bins/2)*Max;
    codebook =  (-bins/2:1:bins/2-1);
    [index,~] = quantiz(Apvec,partition,codebook);
    % save parameters
    Qpar.OriginalSize = OriginalSize; %TODO : see if needed or can use Patch size and Dict size
    Qpar.DC           = DC;
    Qpar.Max          = Max;
    Qpar.header.field = {'OriginalSize','DC','Max'};
    Qpar.header.type  = {'uint16','double','double'};%TODO: check DC/Max double/signel float...
    Apq.Qindex      = index;
    Apq.Qpar        = Qpar;
end