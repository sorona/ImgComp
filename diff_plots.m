function diff_plots(Apd,Hdd,Vdd,Ddd,Wpar,Qpar)
    bins = Qpar.bins;
    figure(); hist(Apd.Diff,bins*2); title('hist for Ap diff')
    AA = figure();
    GG = figure();
    for i = 1:Wpar.level
        ii = (i-1)*3+1;
        
        figure(GG)
            subplot(Wpar.level,3,ii)  ;hist(Hdd{i}.GAMMA.Diff,bins*2); title(sprintf('H%d GAMMA',i));
            subplot(Wpar.level,3,ii+1);hist(Vdd{i}.GAMMA.Diff,bins*2); title(sprintf('V%d GAMMA',i));
            subplot(Wpar.level,3,ii+2);hist(Ddd{i}.GAMMA.Diff,bins*2); title(sprintf('D%d GAMMA',i));
      
        figure(AA)
            subplot(Wpar.level,3,ii)  ;hist(Hdd{i}.A.Diff,bins*2); title(sprintf('H%d A',i));
            subplot(Wpar.level,3,ii+1);hist(Vdd{i}.A.Diff,bins*2); title(sprintf('V%d A',i));
            subplot(Wpar.level,3,ii+2);hist(Ddd{i}.A.Diff,bins*2); title(sprintf('D%d A',i));
    end
    figure(GG); suptitle('Gamma Differences Histograms');
    figure(AA); suptitle('A     Differences Histograms');
end 