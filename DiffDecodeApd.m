function Apq = DiffDecodeApd(Apd)
   % Decode diff Apd
    Diff   = Apd.Diff;
    Dpar   = Apd.Dpar;
    Qindex = zeros(1,length(Diff)+1);
    Qindex(1) = Dpar.start_index; 
    for i=2:length(Qindex)
        Qindex(i) = Qindex(i-1)+Diff(i-1);
    end    
    Apq.Qindex = Qindex;
    Apq.Qpar   = Apd.Qpar; 
    
end