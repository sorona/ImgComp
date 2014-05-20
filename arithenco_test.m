%% Arithenco test
clc;
counts = [100 1]; % A one occurs 99% of the time.
len = 1000;
seq = randsrc(1,len,[1 2; .99 .01]); % Random sequence
code = arithenco(seq,counts);
s = size(code);
dseq = arithdeco(code,counts,length(seq)); % Decode.
    isequal(seq,dseq) % Check that dseq matches the original seq.clc

    
%% Gamma arithenco
clc,close all;
G = load('GAMMAqSamp.mat');

GInd = G.Hdq{2}.GAMMAq.diff;
GIndMin = G.Hdq{2}.GAMMAq.diff_min;

AInd = G.Hdq{2}.Aq.diff;
AIndMin = G.Hdq{2}.Aq.diff_min;

figure; hist(AInd-AIndMin+1,256);
figure; hist(GInd-GIndMin+1,256);

histc(GInd-GIndMin,(1:256));

a = [ 1 1 1 1 1 1 1 1 1 1 2 3 4 5 6];
histc(a,(1:1:6))
 histc(a,(1:1:7))
 histc(a,(0:1:6))