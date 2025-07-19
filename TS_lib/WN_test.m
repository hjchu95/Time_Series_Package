function [BoxPierce, pval_BP, LjungBox, pval_LB, result_df] = WN_test(X,taumax)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Joint hypothesis White Noise test (Box-Pierce and Ljung-Box test)

% Args:
%   X: Objective of estimation (univariate)
%   taumax: Maximum time lag (default = 20)

% Returns:
%   BoxPierce: Test statistic of Box-Pierce test
%   pval_BP: p-value of Box-Pierce test
%   LjungBox: Test statistic of Ljung-Box test
%   pval_LB: p-value of Ljung-Box test

% H0: r(1) = r(2) = ... = r(h) = 0 (Process is White Noise)
% H1: Equality does not hold for some 1<=s<=h (Process is not White Noise)

% Written by Hyun Jae Stephen Chu
% 7, August, 2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 2
    taumax = 20;
else
    taumax = taumax;
end

[T,k] = size(X);

if k > 1
    disp('Warning: X should be a column vector')
    return
else
    cov = autocov(X,taumax);
    corr = cov(2:rows(cov))/cov(1,1);
end

BoxPierce = T*corr'*corr;
pval_BP = (1-cdf('Chi2', BoxPierce, taumax));
s = ones(taumax,1)*T - (1:taumax)';
LjungBox = T*(T+2)*(corr./s)'*corr;
pval_LB = (1-cdf('Chi2', LjungBox, taumax));

sz = [2,2];
VarName = ["Box-Pierce Stat (p-val)","Ljung-Box Stat (p-val)"];
VarType = ["double","double"];
result_df = table('Size',sz,'VariableTypes',VarType,'VariableNames',VarName);

result_df(1,:) = {BoxPierce, LjungBox};
result_df(2,:) = {pval_BP, pval_LB};
disp(" ")
disp(result_df)
disp("* H0:r(1)=r(2)=...=r(h)=0 (Process is White Noise)")
disp("** sig level < p-value = reject H0 under sig level,")
disp("   i.e. process is not White Noise.")

end