function [Ecode,Epar] = arithencoCell(Diff)
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
    if(length(counts)>1) 
        Ecode = arithenco(seq,counts);
    elseif(length(counts)==1)
        Ecode = 0;
    end
    
    Epar.counts = counts;
    Epar.trans  = trans;
    Epar.len    = len;
    
    % TODO : add over flow check
    Epar.header.field = {'counts','trans','len'}; % trans type is 2*bins
    Epar.header.type  = {'uint32','int64','uint32'}; %TODO : try to reduce and check overflow 
end