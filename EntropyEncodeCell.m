function [ Ce ] = EntropyEncodeCell( Cd )
    
    Ce.GAMMA.Qpar  = Cd.GAMMA.Qpar;
    Ce.GAMMA.Dpar  = Cd.GAMMA.Dpar;
    % encode GAMMA
    Diff   = Cd.GAMMA.Diff;
    [Ecode,Epar] = arithencoCell(Diff);
    Ce.GAMMA.Ecode = Ecode;
    Ce.GAMMA.Epar  = Epar;
    Ce.GAMMA.header.field = {'Ecode','Epar','Qpar','Dpar'};
    Ce.GAMMA.header.type  = {'stream','struct','struct','struct'};
    
    
    
    Ce.A.Qpar  = Cd.A.Qpar;
    Ce.A.Dpar  = Cd.A.Dpar;
    % encode A 
    Diff   = Cd.A.Diff;
    [Ecode,Epar] = arithencoCell(Diff);
    Ce.A.Ecode = Ecode;
    Ce.A.Epar  = Epar;
    Ce.A.header.field = {'Ecode','Epar','Qpar','Dpar'};
    Ce.A.header.type  = {'stream','struct','struct','struct'};
    
    % final struct before wirting to file
    Ce.header.field = {'GAMMA','A'};
    Ce.header.type  = {'struct','struct'};
end

