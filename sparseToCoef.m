function [Hrec,Vrec,Drec] = sparseToCoef(H,V,D,Wpar,Kpar)
    level = Wpar.level;
    Hrec  = cell(1,level);
    Vrec  = cell(1,level);
    Drec  = cell(1,level);
    
    for i = 1:level    
         dictLen   = Kpar.dictLen(i);
         patchSize = Kpar.patchSize(i);
         m = sqrt(patchSize);
         n = m;
         B = kron(odctdict(m,sqrt(dictLen)),odctdict(n,sqrt(dictLen)));
         
         Hrec{i} = B*H{i}.A*H{i}.GAMMA;
            Hrec{i} = col2im(Hrec{i},[m n],Wpar.S(level+2-i,:),'distinct');
         Vrec{i} = B*V{i}.A*V{i}.GAMMA;
            Vrec{i} = col2im(Vrec{i},[m n],Wpar.S(level+2-i,:),'distinct');
         Drec{i} = B*D{i}.A*D{i}.GAMMA;
            Drec{i} = col2im(Drec{i},[m n],Wpar.S(level+2-i,:),'distinct');
    end

end

