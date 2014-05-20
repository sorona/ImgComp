function [ Hd,Vd,Dd ] = KsvdDecomposeCells( H,V,D ,level,Patch_size)

    Hd = cell(1,level);
    Vd = cell(1,level);
    Dd = cell(1,level);
    
    for i = 1:level
         [Hd{i}.A ,Hd{i}.GAMMA ]=KsvdCell(H{i},Patch_size);
         [Vd{i}.A ,Vd{i}.GAMMA ]=KsvdCell(V{i},Patch_size);
         [Dd{i}.A ,Dd{i}.GAMMA ]=KsvdCell(D{i},Patch_size);
    end
end

