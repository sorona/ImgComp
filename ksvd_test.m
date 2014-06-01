function ksvd_test(H,V,D,Wpar,Kpar,Patch_size)
[Hd,Vd,Dd] = KsvdDecomposeCells(H,V,D,Wpar,Kpar,Patch_size);
[H_re,V_re,D_re] = sparseToCoef(Hd,Vd,Dd,Wpar.level);
isequal(H{1},H_re{1});
%     for i = 1:level
% %          [Hd{i}.A ,Hd{i}.GAMMA ]=KsvdCell(H{i},Patch_size);
% %          [Vd{i}.A ,Vd{i}.GAMMA ]=KsvdCell(V{i},Patch_size);
% %          [Dd{i}.A ,Dd{i}.GAMMA ]=KsvdCell(D{i},Patch_size);
%     end
end