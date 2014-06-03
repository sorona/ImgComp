function [A , GAMMA]=QuantizeDecodeCell(Cq,bins)
    A     = QuantizationDecodeVec(Cq.A,bins);
    GAMMA = QuantizationDecodeVec(Cq.GAMMA,bins);
end