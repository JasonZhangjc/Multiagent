function [fGFI,phi] = getGFIAB(formula, args, k)

global W Wtotal Z2 ZLoop NM W2;

if length(args)>1
    disp('GG takes a single argument');
    asset(length(args)==1);
end

% number of agents
N = length(W);
% number of states
I = size(W{1},1);
% time horizon
h = size(W{1},2)-1;

ZAnd = [];
z = [];
fGFI = [];

formulaAnd = strcat('And(', num2str(args{1}), ', ZLoop)');
ZAnd = getZ8(formulaAnd,h,NM);
for k = 1:h
    [fLTL,zLTL] = getLTL8(args{1}, k);
    z = [z;zLTL];
    fGFI = [fGFI, fLTL];
    for n = 1:NM  
        fGFI = [fGFI, ZAnd(k,n)<=z(k,n), ZAnd(k,n)<=ZLoop(k), ZAnd(k,n)>=ZLoop(k)+z(k,n)-1];
    end
end

phi = getZ8(formula, 1, NM);
%phi = binvar(1,N);
%Z{length(Z)+1} = {phi,formula};

for n = 1:NM
   fGFI = [fGFI, repmat(phi(n),h,1)>=ZAnd(:,n), phi(n)<=sum(ZAnd(:,n))];
end

    