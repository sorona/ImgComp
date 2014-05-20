function  [A,H,V,D] = getCoefCel( C,S,level,wavelet )

A = cell(1,level);
    H = cell(1,level);
    V = cell(1,level);
    D = cell(1,level);
    
    for i = 1:level
        A{i} = appcoef2(C,S,wavelet,i); % approx
        [H{i} ,V{i} ,D{i}] = detcoef2('a',C,S,i); % details  
    end
    A = A{level};
end

