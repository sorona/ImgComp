function ksvd_experiment()
    R     = {1.5,2,4};  
    C{1} = double(imread('lenna.gif'));
    C{2} = double(imresize(C{1},[128 128]));
%     C{3} = double(imresize(C{1},[16  16]));
%     C{4} = double(imresize(C{1},[64  64 ]));
%     C{5} = double(imresize(C{1},[32  32 ]));
%     C{6} = double(imresize(C{1},[16  16 ]));
%     C{7} = double(imresize(C{1},[8   8  ]));
    % load('KsvdExpVar.mat')
    % load('BugVarForKsvd')
    par.iternum=10;
    par.plots = 1;
    for cc=1:length(C)
        for rr=1:length(R)
            fprintf('**********KSVD EXPERIMENT**********\n');
            fprintf('test for C=%dx%d , R=%.2f\n',size(C{cc}),R{rr})
            par.R=R{rr};
            
            ksvd_pre_run(C{cc},par);
        end
    end
end
