function [CRe] = QuantizeCell(C,Qpar)
    CRe.GAMMA = QunatizeEncodeVec(C.GAMMA,Qpar);
    CRe.A     = QunatizeEncodeVec(C.A,Qpar);

end

