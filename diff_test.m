function diff_test(Apq,Hdq,Vdq,Ddq,Wpar)
    fprintf('******Diff Test begins******\n');
    [Apd,Hdd,Vdd,Ddd] = DiffCodeCells(Apq,Hdq,Vdq,Ddq,Wpar); %TODO: check why Apq has Qpar field
    [ApqR,HdqR,VdqR,DdqR] = DiffDecodeCells(Apd,Hdd,Vdd,Ddd,Wpar); 
    
    err  = zeros(4,1);
    e(1) = (isequal(Apq.Qindex,ApqR.Qindex));
    for i = 1:Wpar.level
        e(2) = isequal(Hdq{i},HdqR{i});
        e(3) = isequal(Vdq{i},VdqR{i});
        e(4) = isequal(Ddq{i},DdqR{i});
    if(max(err)>0)
        error('ERR Diff test failed');
    end
    end
    fprintf('******Diff Test pass*******\n');
end 