function [ Cd ] = DiffCodeCell( Cq )
    Cd.GAMMA.Diff             = diff(Cq.GAMMA.Qindex);
    Cd.GAMMA.Dpar.start_index = Cq.GAMMA.Qindex(1);
    Cd.GAMMA.Dpar.header.field={'start_index'};
    Cd.GAMMA.Dpar.header.type ={'uint64'};
    % overflow check
        if(Cq.GAMMA.Qindex(1)>=2^64)
            error('ERR overflow Dpar.start_index');
        end
    Cd.GAMMA.Qpar             = Cq.GAMMA.Qpar;
    
    Cd.A.Diff             = diff(Cq.A.Qindex);
    Cd.A.Dpar.start_index = Cq.A.Qindex(1);
    Cd.A.Dpar.header.field={'start_index'};
    Cd.A.Dpar.header.type ={'uint64'};
    % overflow check
        if(Cq.A.Qindex(1)>=2^64)
            error('ERR overflow Dpar.start_index');
        end
    Cd.A.Qpar             = Cq.A.Qpar;
end

