function [ Hd,Vd,Dd ] = KsvdDecomposeCells( H,V,D ,Wpar,Kpar,Patch_size)
    level = Wpar.level;
    Hd = cell(1,level);
    Vd = cell(1,level);
    Dd = cell(1,level);
    
    for i = 1:level
         [Hd{i}.A ,Hd{i}.GAMMA ]=KsvdCell(H{i},Kpar,Patch_size);
         [Vd{i}.A ,Vd{i}.GAMMA ]=KsvdCell(V{i},Kpar,Patch_size);
         [Dd{i}.A ,Dd{i}.GAMMA ]=KsvdCell(D{i},Kpar,Patch_size);
    end
end

