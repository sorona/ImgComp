function [Ap,Hd,Vd,Dd] = QuantizeDecodeCells(Apq,Hdq,Vdq,Ddq,level,bins)
    Ap = Apq; % TODO: implement quantize Ap 
    Hd = cell(1,level);
    Vd = cell(1,level);
    Dd = cell(1,level);
    
    for i = 1:level
         [Hd{i}.A , Hd{i}.GAMMA ]=QuantizeDecodeCell(Hdq{i},bins);
         [Vd{i}.A , Vd{i}.GAMMA ]=QuantizeDecodeCell(Vdq{i},bins);
         [Dd{i}.A , Dd{i}.GAMMA ]=QuantizeDecodeCell(Ddq{i},bins);
    end
end
