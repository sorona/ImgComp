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
    Ce.GAMMA.Ecode = Ecode;
    Ce.GAMMA.Epar  = Epar;
    Ce.GAMMA.Qpar  = Cd.GAMMA.Qpar;
    Ce.GAMMA.Dpar  = Cd.GAMMA.Dpar;
    Ce.GAMMA.header.field = {'Ecode','Epar','Qpar','Dpar'};
    Ce.GAMMA.header.type  = {'stream','struct','struct','struct'};
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
    Ce.A.Ecode = Ecode;
    Ce.A.Epar  = Epar;
    Ce.A.Qpar  = Cd.A.Qpar;
    Ce.A.Dpar  = Cd.A.Dpar;
    Ce.A.header.field = {'Ecode','Epar','Qpar','Dpar'};
    Ce.A.header.type  = {'stream','struct','struct','struct'};
    
    Ce.header.field = {'GAMMA','A'};
    Ce.header.type  = {'struct','struct'};
end

