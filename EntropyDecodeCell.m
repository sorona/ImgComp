function Cd = EntropyDecodeCell(Ce)
    % Decode GAMMA
    Ecode  = Ce.GAMMA.Ecode;
    counts = Ce.GAMMA.Epar.counts;
    trans  = Ce.GAMMA.Epar.trans;
    len    = Ce.GAMMA.Epar.len;   
    
    Diffr = zeros(1,len);
    if(length(counts)>1)
            Dseq = arithdeco(Ecode,counts,len);
        for i=1:length(trans)
           ind = Dseq==i;
           Diffr(ind) = trans(i);
        end
    elseif(length(counts)==1)
        Diffr(1:end)=trans(1)';
    end
    
    Cd.GAMMA.Diff = Diffr;
    Cd.GAMMA.Dpar = Ce.GAMMA.Dpar;
    Cd.GAMMA.Qpar = Ce.GAMMA.Qpar;
    
    % Decode A
    Ecode  = Ce.A.Ecode;
    counts = Ce.A.Epar.counts;
    trans  = Ce.A.Epar.trans;
    len    = Ce.A.Epar.len;   
    
    Diffr = zeros(1,len);
    if(length(counts)>1)
            Dseq = arithdeco(Ecode,counts,len);
        for i=1:length(trans)
           ind = Dseq==i;
           Diffr(ind) = trans(i);
        end
    elseif(length(counts)==1)
        Diffr(1:end)=trans(1)';
    end
    
    Cd.A.Diff = Diffr;
    Cd.A.Dpar = Ce.A.Dpar;
    Cd.A.Qpar = Ce.A.Qpar;
end