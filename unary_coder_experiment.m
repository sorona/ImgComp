function unary_coder_experiment()
% Packedbits encoding
load('HddSamp.mat')
fprintf('******Unary coder experiment *****\n')
Diff = Hdd{1}.GAMMA.Diff;
figure;hist(Diff,604);
% test 
%  Diff= [2 1 6];
%  Diff=[ 0 1 2];
 
%  Diff=[ 0 1 2 5  10 2 0 1 2131 -4];

% unary encoding
 diffSign = Diff<0;
 diffAbs = abs(Diff);
unStream = [];
for i=1:length(Diff)
    unStream = [unStream ones(1,Diff(i)) 0];
end


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
ind    = diffSign==1;
diffRe = diffAbs; diffRe(ind) = -(diffRe(ind));

DiffRe;
length(Diff)/length(unStream);
isequal(Diff,DiffRe)
% arith encoding 
fprintf('******Unary coder experiment done*****\n')


end