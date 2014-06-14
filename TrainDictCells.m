function [Dict] = TrainDictCells(H,V,D,Wpar,Kpar)
    % train dictionary for each level each directions
    level   = Wpar.level;
    Dict = cell(3,level);
    
    band = {'H','V','D'};
    % for each level each dirction train dictionary
    for i = 1:level
        for j=1:length(band)
            Kpar.name  = sprintf('%s{%d}',band{j},i);
            B          = eval(Kpar.name);
            Dict{j,i} = TrainDict(B,Kpar);        
        end
    end

end