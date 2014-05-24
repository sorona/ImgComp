function Cq = DiffDecodeCell(Cd)
    % Decode diff GAMMA
    Diff   = Cd.GAMMA.Diff;
    Dpar   = Cd.GAMMA.Dpar;
    Qindex = zeros(1,length(Diff)+1);
    Qindex(1) = Dpar.start_index; 
    for i=2:length(Qindex)
        Qindex(i) = Qindex(i-1)+Diff(i-1);
    end    
    Cq.GAMMA.Qindex = Qindex;
    Cq.GAMMA.Qpar   = Cd.GAMMA.Qpar; 
    
    % Decode diff A
    Diff   = Cd.A.Diff;
    Dpar   = Cd.A.Dpar;
    Qindex = zeros(1,length(Diff)+1);
    Qindex(1) = Dpar.start_index; 
    for i=2:length(Qindex)
        Qindex(i) = Qindex(i-1)+Diff(i-1);
    end    
    Cq.A.Qindex = Qindex;
    Cq.A.Qpar   = Cd.A.Qpar;
end