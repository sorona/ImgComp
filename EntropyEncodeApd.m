function Ape = EntropyEncodeApd(Apd)
    % encode Apd
    Diff   = Apd.Diff;
    [Ecode,Epar] = arithencoCell(Diff);
    % TODO : add over flow check
    Epar.header.field = {'counts','trans','len'}; % trans type is 2*bins
    Epar.header.type  = {'uint32','int64','uint32'}; %TODO : try to reduce and check overflow 
    Ape.Ecode = Ecode;
    Ape.Epar  = Epar;
    Ape.Qpar  = Apd.Qpar;
    Ape.Dpar  = Apd.Dpar;
    Ape.header.field = {'Ecode','Epar','Qpar','Dpar'};
    Ape.header.type  = {'stream','struct','struct','struct'};
end