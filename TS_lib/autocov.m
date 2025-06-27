function cov = autocov(X,taumax)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimating the Autocovariance function (ACF) of a univariate process

% Args:
%   X: Objective of estimation (univariate)
%   taumax: Maximum time lag (default = 20)

% Returns:
%   cov: Estimated autocovariance function, taumax+1 by 1

% Written by Hyun Jae Stephen Chu
% August 7th, 2024
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
    Xm = mean(X);
    Xd = X - ones(T,1)*Xm; % demeaned X
    cov = zeros(taumax+1,1);
    for i = 0:taumax
        cov(i+1) = (1/T)*Xd(i+1:T,1)'*Xd(1:T-i,1);
    end
end

end