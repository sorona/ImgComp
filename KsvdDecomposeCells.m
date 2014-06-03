function [ Hd,Vd,Dd,KparRe] = KsvdDecomposeCells( H,V,D ,Wpar,Kpar)
    
    level   = Wpar.level;
    Hd = cell(1,level);
    Vd = cell(1,level);
    Dd = cell(1,level);
    
    KparRe = Kpar;
    KparRe.dictLen   = zeros(level,1);
    KparRe.patchSize = zeros(level,1);
    
    for i = 1:level
         [Hd{i}.A ,Hd{i}.GAMMA,~     ]=KsvdCell(H{i},Kpar);
         [Vd{i}.A ,Vd{i}.GAMMA,~     ]=KsvdCell(V{i},Kpar);
         [Dd{i}.A ,Dd{i}.GAMMA,parRe ]=KsvdCell(D{i},Kpar);
         KparRe.dictLen(i)   = parRe.dictLen;
         KparRe.patchSize(i) = parRe.patchSize;
    end
    
end

