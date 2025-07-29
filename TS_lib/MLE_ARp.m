function [theta] = MLE_ARp(y,p,option)
% =========================================================================
% DESCRIPTION
% Esimation of the AR(p) Model using MLE

% -------------------------------------------------------------------------
% INPUT AND OUTPUTS
% Args:
%   y: data of the AR(p) model
%   p: Lag of AR(p) model
%   option: option for displaying fminsearch process
%       - 0 = do not display
%       - 1 = display

% Returns:
%   log_lik: log-likelihood of the AR(p) model

% -------------------------------------------------------------------------
% Written by Hyun Jae Stephen Chu
% July 29th, 2025
% =========================================================================
if nargin < 3
    option = 0;
end

if option == 0
    disp_option = 'off';
else
    disp_option = 'iter';
end

% <Step 1>: Initial parameters (Guess by OLS)
T = rows(y);
Y0 = y(p+1:end,:); % LHS variable
T1 = rows(Y0); % length of the AR(p) model

% Determining the RHS variable
Y_lag = zeros(T1,p);
for j = 1:p
    Y_lag(:,j) = y(p+1-j:T-j,:);
end

X = [ones(T1,1),Y_lag];

% Estimating the OLS estimator
XX = X' * X;
phi_hat = (XX)\(X'*Y0);

% Estimating the variance-covariance matrix
y_hat = X*phi_hat;
u_hat = Y0 - y_hat;
sig2_hat = (u_hat'*u_hat) / (T1-p);
theta_init = [phi_hat',sig2_hat]';

% <Step 2>: Set objective function
objFun = @(theta) -1*arp_lnlik(theta,y,p);

options = optimset('Display', disp_option, 'MaxIter', 5000, 'MaxFunEvals', 5000);

% <Step 3>: Find Optimizer
[para,fval,exitflag] = fminsearch(objFun, theta_init, options);

theta = [para(1,1);flip(para(2:end-1));para(end)];