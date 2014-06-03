function [Apq,Hdq,Vdq,Ddq] = DiffDecodeCells(Apd,Hdd,Vdd,Ddd,Wpar)
    level = Wpar.level;
    Apq = DiffDecodeApd(Apd); 
    Hdq = cell(1,level);
    Vdq = cell(1,level);
    Ddq = cell(1,level);
    for i = 1:level
         Hdq{i} = DiffDecodeCell(Hdd{i});
         Vdq{i} = DiffDecodeCell(Vdd{i});
         Ddq{i} = DiffDecodeCell(Ddd{i});
    end
end