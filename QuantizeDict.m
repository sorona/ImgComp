function DictQ = QuantizeDict(Dict,Qpar)
    DictQ = cell(size(Dict));
    for i=1:size(DictQ,2)
        for j=1:size(DictQ,1)
            DictQ{i,j}  = QunatizeEncodeVec(Dict{i,j},Qpar);
        end
    end
end
