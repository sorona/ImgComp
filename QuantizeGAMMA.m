function GAMMAQ = QuantizeGAMMA(GAMMA,Qpar)
    GAMMAQ = cell(size(GAMMA));
    for i=1:size(GAMMAQ,1)
        for j=1:size(GAMMAQ,2)
            GAMMAQ{i,j}  = QunatizeEncodeVec(GAMMA{i,j},Qpar);
        end
    end
 
 
 end