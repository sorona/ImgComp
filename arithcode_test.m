function arithcode_test(Apd,Hdd,Vdd,Ddd,Wpar)
    fprintf('******Arithcode Test begins******\n');
    [Ape,Hde,Vde,Dde] = EntropyEncodeCells(Apd,Hdd,Vdd,Ddd,Wpar);
    [ApdR,HddR,VddR,DddR] = EntropyDecodeCells(Ape,Hde,Vde,Dde,Wpar); 
    err = zeros(4,1);
    err(1) = isequal(Apd,ApdR);
    err(2) = isequal(Hdd,HddR);
    err(3) = isequal(Vdd,VddR);
    err(4) = isequal(Ddd,DddR);
    if(min(err)<1)
        error('ERR Arithcode Test Fail')
    end
    fprintf('******Arithcode Test pass\n******')
end