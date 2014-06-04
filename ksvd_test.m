function ksvd_test(H,V,D,Wpar,Kpar)
 fprintf('******KSVD Test begins******\n');
 Kpar.plots = 0; % don't plot the test
[Hd,Vd,Dd,KparRe] = KsvdDecomposeCells(H,V,D,Wpar,Kpar);
[H_re,V_re,D_re]  = sparseToCoef(Hd,Vd,Dd,Wpar,KparRe);

for i = 1:Wpar.level
    err =         norm(H{i}-H_re{i},'fro')/norm(H{i},'fro');
    err = max(err,norm(V{i}-V_re{i},'fro')/norm(V{i},'fro'));
    err = max(err,norm(D{i}-D_re{i},'fro')/norm(D{i},'fro'));
    if(err>10^-3)
        error('ERR ksvd test failed');
    end
end
    fprintf('******KSVD Test pass******\n');
end