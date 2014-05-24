function [Apq,Hdq,Vdq,Ddq] = DiffDecodeCells(Apd,Hdd,Vdd,Ddd,level)
    Apq = Apd; % TODO: implement diff Ap 
    Hdq = cell(1,level);
    Vdq = cell(1,level);
    Ddq = cell(1,level);
    for i = 1:level
         Hdq{i} = DiffDecodeCell(Hdd{i});
         Vdq{i} = DiffDecodeCell(Vdd{i});
         Ddq{i} = DiffDecodeCell(Ddd{i});
    end
end