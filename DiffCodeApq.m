function Apd = DiffCodeApq(Apq)
    Apd.Diff             = diff(Apq.Qindex);
    Apd.Dpar.start_index = Apq.Qindex(1);
    Apd.Dpar.header.field={'start_index'};
    Apd.Dpar.header.type ={'uint64'};
    % overflow check
        if(Apq.Qindex(1)>=2^64)
            error('ERR overflow Dpar.start_index');
        end
    Apd.Qpar             = Apq.Qpar;
end