function [ Cd ] = DiffCodeCell( Cq )
    Cd.GAMMA.diff             = diff(Cq.GAMMA.Qindex);
    Cd.GAMMA.Dpar.start_index = Cq.GAMMA.Qindex(1);
    Cd.GAMMA.Qpar             = Cq.GAMMA.Qpar;
    
    Cd.A.diff             = diff(Cq.A.Qindex);
    Cd.A.Dpar.start_index = Cq.A.Qindex(1);
    Cd.A.Qpar             = Cq.A.Qpar;
end

