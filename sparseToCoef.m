function [Hrec,Vrec,Drec] = sparseToCoef(H,V,D,level)

    Hrec = cell(1,level);
    Vrec = cell(1,level);
    Drec = cell(1,level);
    
    for i = 1:level
        
         B = kron(odctdict(8,8),odctdict(8,8));%TODO: remove (learned dict)
         %R = B*A*Gamma;
         
         Hrec{i} = B*H{i}.A*H{i}.GAMMA;
            Level_size = sqrt(size(Hrec{i},1)*size(Hrec{i},2));
            Hrec{i} = col2im(Hrec{i},[8 8],[Level_size Level_size],'distinct');
         Vrec{i} = B*V{i}.A*V{i}.GAMMA;
            Vrec{i} = col2im(Vrec{i},[8 8],[Level_size Level_size],'distinct');
         Drec{i} = B*D{i}.A*D{i}.GAMMA;
            Drec{i} = col2im(Drec{i},[8 8],[Level_size Level_size],'distinct');
    end

end

