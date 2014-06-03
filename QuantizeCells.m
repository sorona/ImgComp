function [Apq,Hdq,Vdq,Ddq] = QuantizeCells( Ap,Hd,Vd,Dd,Wpar,Qpar)
    level = Wpar.level;
    bins  = Qpar.bins;
    Apq = QuantizeAp(Ap,bins); % TODO: implement quantize Ap 
    Hdq = cell(1,level);
    Vdq = cell(1,level);
    Ddq = cell(1,level);
    
    for i = 1:level
         [Hdq{i}]=QuantizeCell(Hd{i},Qpar);
         [Vdq{i}]=QuantizeCell(Vd{i},Qpar);
         [Ddq{i}]=QuantizeCell(Dd{i},Qpar);
    end
end

