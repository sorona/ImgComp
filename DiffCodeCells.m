function [Apd,Hdd,Vdd,Ddd] = DiffCodeCells(Apq,Hdq,Vdq,Ddq,level)
    Apd = DiffCodeApq(Apq); % TODO: implement diff Ap 
    Hdd = cell(1,level);
    Vdd = cell(1,level);
    Ddd = cell(1,level);
    for i = 1:level
         Hdd{i} = DiffCodeCell(Hdq{i});
         Vdd{i} = DiffCodeCell(Vdq{i});
         Ddd{i} = DiffCodeCell(Ddq{i});
    end
end

