function diff_experiment(file_name)
% Difference coding test
load(file_name)
Hdq2 = Hdq{2};
G = Hdq2.GAMMA; 
% simple test
% G.index = [1 2 3 3 3  4 5]

% encoding
Gd  = diff(G.Qindex);
Dpar.start_index = G.Qindex(1);

% decoding
Gr    = zeros(1,length(Gd)+1);
Gr(1) = Dpar.start_index; 
for i=2:length(Gr)
    Gr(i) = Gr(i-1)+Gd(i-1);
end

% test
isequal(Gr',G.Qindex);

end 