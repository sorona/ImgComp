function [ Ce ] = EntropyEncodeCell( Cd )
    % encode GAMMA
    Diff   = Cd.GAMMA.Diff;
    [Ecode,Epar] = arithencoCell(Diff);
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
    [Ecode,Epar] = arithencoCell(Diff);
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

