function arithcode_test(file_name)
load(file_name);    
Diff = Hdd{2}.GAMMA.Diff;
% figure();hist(diff);
% simple diff
% Diff   = [1 3 - 4 -4 -5 2 2]

% encode 
Min    = min(Diff);
Max    = max(Diff);
seq    = zeros(size(Diff));
counts = zeros(size(Diff));
trans  = zeros(size(Diff));
t = 1;
for i = Min:1:Max
    ind       = Diff==i;
    if(max(ind))
        counts(t) = sum(ind);
        trans(t)  = i; 
        seq(ind)  = t;
        t = t+1;
    end
end
counts = counts(1:t-1);
trans  = trans(1:t-1);
len    = length(seq);

Ecode = arithenco(seq,counts) ;
% compression rate rought estimation
% for 8 bit quantization
rate = length(Ecode)/(8*length(seq));
fprintf('arithcode compression rate rough estimation for 8 bit on Hdd2 %.3f\n',rate);
%TODO: make estimation depndend on bins

% decode
Diffr = zeros(1,len);
Dseq = arithdeco(Ecode,counts,len);
for i=1:length(trans)
   ind = Dseq==i;
   Diffr(ind) = trans(i);
end
 isequal(Diffr',Diff)
end