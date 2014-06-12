function Ape = EntropyEncodeApd(Apd)
    Ape.Qpar  = Apd.Qpar;
    Ape.Dpar  = Apd.Dpar;
    % encode Apd
    Diff   = Apd.Diff;
    [Ecode,Epar] = arithencoCell(Diff);
    % final struct before wirting to file
    Ape.Ecode = Ecode;
    Ape.Epar  = Epar;
    Ape.header.field = {'Ecode','Epar','Qpar','Dpar'};
    Ape.header.type  = {'stream','struct','struct','struct'};
end