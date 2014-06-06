function arithcode_test(Apd,Hdd,Vdd,Ddd,Wpar,Qpar)
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
    
    gammaCompRate = zeros(Wpar.level,3);
    AcompRate     = zeros(Wpar.level,3);
    for i = 1:Wpar.level
       gammaCompRate(i,1) = length(Hde{i}.GAMMA.Ecode)/(length(Hdd{i}.GAMMA.Diff)*Qpar.bins);
       gammaCompRate(i,2) = length(Vde{i}.GAMMA.Ecode)/(length(Vdd{i}.GAMMA.Diff)*Qpar.bins);
       gammaCompRate(i,3) = length(Dde{i}.GAMMA.Ecode)/(length(Ddd{i}.GAMMA.Diff)*Qpar.bins);
       
       AcompRate(i,1) = length(Hde{i}.A.Ecode)/(length(Hdd{i}.A.Diff)*Qpar.bins);
       AcompRate(i,2) = length(Vde{i}.A.Ecode)/(length(Vdd{i}.A.Diff)*Qpar.bins);
       AcompRate(i,3) = length(Dde{i}.A.Ecode)/(length(Ddd{i}.A.Diff)*Qpar.bins);
    end 
    gammaCompMax      = max(max(gammaCompRate));
    gammaCompMin      = min(min(gammaCompRate));
    gammaCompRatemean = mean(mean(gammaCompRate));
    gammaCompStd      = std(mean(gammaCompRate));
    fprintf('Wavelet GAMMA Differences to Entropy\n    Compression mean rate=%.3f std=%.3f min=%.3f max=%.3f\n'...
        ,gammaCompRatemean...
        ,gammaCompStd...
        ,gammaCompMin...
        ,gammaCompMax);
    
    AcompMax      = max(max(AcompRate));
    AcompMin      = min(min(AcompRate));
    AcompRatemean = mean(mean(AcompRate));
    AcompStd      = std(mean(AcompRate));
    fprintf('Wavelet A Differences to Entropy\n    Compression mean rate=%.3f std=%.3f min=%.3f max=%.3f\n'...
        ,AcompRatemean...
        ,AcompStd...
        ,AcompMin...
        ,AcompMax);
     
    approxCompRate = length(Ape.Ecode)/(length(Apd.Diff)*Qpar.bins);
    fprintf('Approx A Differences to Entropy Compression rate=%.3f\n',approxCompRate);
    
    fprintf('******Arithcode Test pass******\n')
end