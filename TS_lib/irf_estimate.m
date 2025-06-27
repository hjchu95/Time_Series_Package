function Theta = irf_estimate(F,p,H,B0inv)
% =========================================================================
% DESCRIPTION
% Estimating the impulse-response function

% -------------------------------------------------------------------------
% INPUT AND OUTPUTS
% Args:
%   A_hat: Estimated coefficient matrix of reduced-form VAR(p) model
%   Sigma_hat: Estimated variance-covariance matrix of reduced-form VAR(p)
%   model
%   restrict: Identification method to use
%       (1) short = Short-run, recursive restriction
%       (2) long = Long-run restriction

% Returns:
%   B0inv: Identified B0 inverse matrix of the structural-form VAR(p) model

% -------------------------------------------------------------------------
% Written by Hyun Jae Stephen Chu
% March 30th, 2025
% =========================================================================
K = rows(B0inv);
FF = eye(p*K); % size of the companion form
vecB0inv = vec(B0inv');
% first K rows: effect of the first shock on response
% second K rows: effect of the second shock on response
% third K rows: effect of the third shock on response

Theta = vecB0inv; % to store IRFs

for h = 1:H
    FF = F*FF;
    theta = FF(1:K,1:K) * B0inv;
    theta = vec(theta');
    Theta = [Theta, theta];
end

end