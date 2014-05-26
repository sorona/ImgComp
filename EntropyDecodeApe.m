function Apd = EntropyDecodeApe(Ape)
   % Decode Ape
    Ecode  = Ape.Ecode;
    counts = Ape.Epar.counts;
    trans  = Ape.Epar.trans;
    len    = Ape.Epar.len;   
    
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
    
    Apd.Diff = Diffr;
    Apd.Dpar = Ape.Dpar;
    Apd.Qpar = Ape.Qpar;
 end