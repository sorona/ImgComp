function [ Ce ] = EntropyEncodeCell( Cd )

    % encode GAMMA
    Diff   = Cd.GAMMA.Diff;
    Min    = min(Diff);
    Max    = max(Diff);
    seq    = zeros(size(Diff));
    counts = zeros(size(Diff));
    trans  = zeros(size(Diff));
    t = 1;
    for i = Min:1:Max
        ind       = Diff==i;
        if(max(ind))
            counts(t) = sum(ind);
            trans(t)  = i; 
            seq(ind)  = t;
            t = t+1;
        end
    end
    counts = counts(1:t-1);
    trans  = trans(1:t-1);
    len    = length(seq);
    Ecode  = arithenco(seq,counts) ;
    
    Epar.counts = counts;
    Epar.trans  = trans;
    Epar.len    = len;
    Ce.GAMMA.Ecode = Ecode;
    Ce.GAMMA.Epar  = Epar;
    Ce.GAMMA.Qpar  = Cd.GAMMA.Qpar;
    Ce.GAMMA.Dpar  = Cd.GAMMA.Dpar;
    
    % encode A 
    Diff   = Cd.A.Diff;
    Min    = min(Diff);
    Max    = max(Diff);
    seq    = zeros(size(Diff));
    counts = zeros(size(Diff));
    trans  = zeros(size(Diff));
    t = 1;
    for i = Min:1:Max
        ind       = Diff==i;
        if(max(ind))
            counts(t) = sum(ind);
            trans(t)  = i; 
            seq(ind)  = t;
            t = t+1;
        end
    end
    counts = counts(1:t-1);
    trans  = trans(1:t-1);
    len    = length(seq);
    Ecode  = arithenco(seq,counts) ;
    
    Epar.counts = counts;
    Epar.trans  = trans;
    Epar.len    = len;
    Ce.A.Ecode = Ecode;
    Ce.A.Epar  = Epar;
    Ce.A.Qpar  = Cd.A.Qpar;
    Ce.A.Dpar  = Cd.A.Dpar;
end

