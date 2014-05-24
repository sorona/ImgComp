function [Apd,Hdd,Vdd,Ddd] = EntropyDecodeCells(Ape,Hde,Vde,Dde,level)
    Apd = Ape; % TODO: implement diff Ap 
    Hdd = cell(1,level);
    Vdd = cell(1,level);
    Ddd = cell(1,level);
    for i = 1:level
         Hdd{i} = EntropyDecodeCell(Hde{i});
         Vdd{i} = EntropyDecodeCell(Vde{i});
         Ddd{i} = EntropyDecodeCell(Dde{i});
    end
end