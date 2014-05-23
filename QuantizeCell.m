function [ A, GAMMA ] = QuantizeCell( C,bins )
    
    % Quantize encode GAMMA
    OriginalSize = size(C.GAMMA); 
    GAMMAv = Gamma2vec(C.GAMMA);
    GAMMAv = GAMMAv';
    DC     = mean(full(GAMMAv));
    GAMMAv = GAMMAv-DC;
    Max    = max(abs(GAMMAv));
    % encode
    partition = ((-bins/2:1:bins/2-2)+0.5)/(bins/2)*Max;
    codebook =  (-bins/2:1:bins/2-1);
    [index,~] = quantiz(GAMMAv,partition,codebook);
    % save parameters
    Qpar.OriginalSize = OriginalSize; %TODO : see if needed or can use Patch size and Dict size
    Qpar.DC           = DC;
    Qpar.Max          = Max;
    Qpar.header.field = {'OriginalSize','DC','Max'};
    Qpar.header.type  = {'uint16','double','double'};%TODO: check DC/Max double/signel float...
    GAMMA.Qindex      = index';
    GAMMA.Qpar        = Qpar;

    % Quantize encode A
    OriginalSize = size(C.A);
    Av          = Gamma2vec(C.A); % TODO: replace with A2vec
    AV          = Av';
    DC          = mean(full(Av));
    Av          = Av-DC;
    Max         = max(abs(Av));
    % encode
    partition = ((-bins/2:1:bins/2-2)+0.5)/(bins/2)*Max;
    codebook =  (-bins/2:1:bins/2-1);
    [index,~] = quantiz(Av,partition,codebook);
    % save parameters
    Qpar.OriginalSize = OriginalSize;
    Qpar.DC          = DC;
    Qpar.Max         = Max;
    Qpar.header.field = {'OriginalSize','DC','Max'};
    Qpar.header.type  = {'uint16','double','double'};%TODO: check DC/Max double/signel float...
    A.Qindex         = index';
    A.Qpar           = Qpar;
    
end

