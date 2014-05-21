function arithcode_test(file_name)
load(file_name);    
Diff = Hdd{2}.GAMMA.Diff;
% figure();hist(diff);
% simple diff
% Diff   = [1 3 - 4 -4 -5 2 2]
% zeros case
% Diff   = [0 0 0 0 0 0 0]

%% encode (full sparse matrix)
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

if(length(counts)>1) 
    Ecode = arithenco(seq,counts);
elseif(length(counts)==1)
    Ecode = 0;
end
% compression rate rought estimation
% for 8 bit quantization
rate = length(Ecode)/(8*length(seq));
fprintf('arithcode test compression rate rough estimation for 8 bit on Hdd2 %.3f\n',rate);
%TODO: make estimation depndend on bins and quantization
%% encode ver2 (coeff asade) 
 ind = 1:1:length(Diff);
 nonZind = Diff ~= 0;
 Diff2   = Diff(nonZind);
 nonZind = ind(nonZind);
 
Min2    = min(Diff2);
Max2    = max(Diff2);
seq2    = zeros(size(Diff2));
counts2 = zeros(size(Diff2));
trans2  = zeros(size(Diff2));
t = 1;
for i = Min2:1:Max2
    ind       = Diff2==i;
    if(max(ind))
        counts2(t) = sum(ind);
        trans2(t)  = i; 
        seq2(ind)  = t;
        t = t+1;
    end
end
counts2 = counts2(1:t-1);
trans2  = trans2(1:t-1);
len2    = length(seq2);

if(length(counts2)>1) 
    Ecode2 = arithenco(seq2,counts2);
elseif(length(counts2)==1)
    Ecode2 = 0;
end
rate2 = (length(Ecode2)+length(nonZind)*16)/(8*length(seq));
fprintf('arithcode test ver2 compression rate rough estimation for 8 bit on Hdd2 %.3f\n',rate2);


%% decode
Diffr = zeros(1,len);
if(length(counts)>1)
        Dseq = arithdeco(Ecode,counts,len);
    for i=1:length(trans)
       ind = Dseq==i;
       Diffr(ind) = trans(i);
    end
elseif(length(counts)==1)
    Diffr(1:end)=trans(1)';
end
 res = isequal(Diffr,Diff);
 fprintf('arithenco/deco test isequal=%d\n',res);
 
end