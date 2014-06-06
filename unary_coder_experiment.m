function packbits_experiment()
% Packedbits encoding
load('HddSamp.mat')
Diff = Hdd{1}.GAMMA.Diff;
figure;hist(Diff,604);
% test 
%  Diff= [2 1 6];
%  Diff=[ 0 1 2];
% unary encoding
unStream = [];
for i=1:length(Diff)
    unStream = [unStream ones(1,Diff(i)) 0];
end
unStream;
DiffRe  =[];
ReNum=0;
for i=1:length(unStream)
    switch unStream(i)
        case 0
            DiffRe=[DiffRe ReNum];
            ReNum=0;
        case 1
            ReNum = ReNum+1;
    end
end
DiffRe;
length(Diff)/length(unStream)

% arith encoding 




end