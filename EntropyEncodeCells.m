function [Ape,Hde,Vde,Dde] = EntropyEncodeCells(Apd,Hdd,Vdd,Ddd,level)
    Ape = EntropyEncodeApd(Apd); % TODO: implement entroy encode Ap, do test to check if needed ??
    Hde = cell(1,level);
    Vde = cell(1,level);
    Dde = cell(1,level);
    for i = 1:level
         Hde{i} = EntropyEncodeCell(Hdd{i});
         Vde{i} = EntropyEncodeCell(Vdd{i});
         Dde{i} = EntropyEncodeCell(Ddd{i});
    end
end

