function [Apq,Hdq,Vdq,Ddq] = QuantizeCells( Ap,Hd,Vd,Dd,level,bins )
    
    Apq = QuantizeAp(Ap,bins); % TODO: implement quantize Ap 
    Hdq = cell(1,level);
    Vdq = cell(1,level);
    Ddq = cell(1,level);
    
    for i = 1:level
         [Hdq{i}.A , Hdq{i}.GAMMA ]=QuantizeCell(Hd{i},bins);
         [Vdq{i}.A , Vdq{i}.GAMMA ]=QuantizeCell(Vd{i},bins);
         [Ddq{i}.A , Ddq{i}.GAMMA ]=QuantizeCell(Dd{i},bins);
    end
end

