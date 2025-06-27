function [p_seq,p_aic,p_bic,p_hq] = orderVAR(y,pmax)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Esimation of Optimal VAR(p) Order

% Args:
%   y: Response variable vector of VAR(p) model
%   pmax: Expected maximum lag of VAR(p) model

% Returns:
%   p_seq: Optimal lag order estimated by sequential testing
%   p_aic: Optimal lag order estimated by Akaike information criteria (AIC)
%   p_bic: Optimal lag order estimated by Bayesian information criteria (BIC)
%   p_hq: Optimal lag order estimated by Hannan-Quinn information criteria (HQIC)

% Written by Hyun Jae Stephen Chu
% 2, October, 2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[T,K] = size(y);

% For saving
lnSig = zeros(pmax+1,1);

% Preparing
Y = y(pmax+1:T,:); % initial LHS
Z = ones(T-pmax,1); % initial constant term
ZZ = Z'*Z;
B = inv(ZZ)*(Z'*Y); % OLS estimator
U = Y - Z*B; % residual
Sig = (U'*U)/(T-pmax); % initial Sigma hat
lnSig(1,1) = log(det(Sig)); % log determinant of variance of OLS estimator

for p=1:pmax % constructing RHS variables
    Z = [Z,y(pmax+1-p:T-p,:)];
    ZZ = Z'*Z;
    B = inv(ZZ)*(Z'*Y);
    U = Y - Z*B;
    Sig = (U'*U)/(T-pmax);
    lnSig(p+1,1) = log(det(Sig));
end

% Sequential Testing
LRstat = (T-pmax)*(lnSig(1:pmax,1)-lnSig(2:pmax+1,1)); % sequence of LR test statistics
cv=icdf('chi2',0.95,K^2); % critical value
reject=(LRstat>cv);
if sum(reject)==0 % non-reject in all cases
    p_seq=0;
else
    p_seq=find(reject,1,'last'); % find where a rejection occurs for the first time
end

% Information Criteria
AIC = lnSig + (2)*(K^2*(0:pmax)'+K*ones(pmax+1,1))/(T-pmax); % vector with respect to p=0,...,pmax
BIC = lnSig + (log(T-pmax))*(K^2*(0:pmax)'+K*ones(pmax+1,1))/(T-pmax);
HQ = lnSig + (2*log(log(T-pmax)))*(K^2*(0:pmax)'+K*ones(pmax+1,1))/(T-pmax);
[~,ind_aic] = min(AIC);
p_aic = ind_aic-1; % excluding p=0
[~,ind_bic] = min(BIC);
p_bic = ind_bic-1;
[~,ind_hq] = min(HQ);
p_hq = ind_hq-1;

disp('  ')
s1 = sprintf( ' VAR order selected by Sequential Testing = %4d ', p_seq);
s2 = sprintf( ' VAR order selected by AIC = %4d ', p_aic);
s3 = sprintf( ' VAR order selected by BIC = %4d ', p_bic);
s4 = sprintf( ' VAR order selected by HQ  = %4d ', p_hq);
disp(s1)
disp(s2)
disp(s3)
disp(s4)

end