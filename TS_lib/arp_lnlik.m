function [log_lik] = arp_lnlik(theta,y,p)
% =========================================================================
% DESCRIPTION
% Deriving the log-likelihood of an AR(p) Model

% -------------------------------------------------------------------------
% INPUT AND OUTPUTS
% Args:
%   theta: parameter set of AR(p) model
%       - saved as the (intercept, coefficients, sigma2) order
%   y: data of the AR(p) model
%   p: Lag of AR(p) model

% Returns:
%   log_lik: log-likelihood of the AR(p) model

% -------------------------------------------------------------------------
% Written by Hyun Jae Stephen Chu
% July 29th, 2025
% =========================================================================
% Load Parameters
mu = theta(1);
alpha = theta(2:end-1);
sig2 = theta(end);

T = rows(y);
u_hat = zeros(T-p,1);
for t = p+1:T
    y_hat = mu + alpha'*y(t-p:t-1);
    u_hat(t-p) = y(t) - y_hat;
end
u_hat2 = u_hat'*u_hat;

log_lik = -(T-p)/2*log(2*pi) - (T-p)/2*log(sig2) ...
    - (1/(2*sig2))*u_hat2;

end