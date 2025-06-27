function [A_hat, Sigma_hat, F, Y0, Y_lag, U_hat, Y_pred] = OLS_VAR(y, p, h)
% =========================================================================
% DESCRIPTION
% Esimation of the reduced-form VAR(p) Model

% -------------------------------------------------------------------------
% INPUT AND OUTPUTS
% Args:
%   y: Response variable matrix of VAR(p) model (multivariate)
%   p: Optimal lag of VAR(p) model
%   H: Maximum forecasting horizon, does not forecast if None

% Returns:
%   A_hat: Coefficient matrix estimator of reduced-form VAR(p) model
%   Sigma_hat: Variance-covariance matrix estimator
%   F: Companion form of OLS estimators
%   Y0: Response variables used in estimation
%   Y_lag: Explanatory variables used in estimation
%   Y_predm: Predicted value

% -------------------------------------------------------------------------
% NOTES
% - Variables are demeaned to not consider the intercept term for simplicity
% - The eliminated mean must later be added back to the demeaned variables,
%   the fitted and predicted value.

% -------------------------------------------------------------------------
% SUBFUNCTIONS
% - rows, meanc, demeanc, vec

% -------------------------------------------------------------------------
% Written by Hyun Jae Stephen Chu
% March 30th, 2025
% =========================================================================
if nargin == 3
    H = h;
else
    H = 0;
    % disp(" ")
    % disp("H=0 since some input variables are None.")
end

% 1. Demeaning and Determining the LHS variable
Y_ = meanc(y);
Y = demeanc(y);
[T,K] = size(y);
Y0 = Y(p+1:T,:); % T-p by K
T1 = rows(Y0);

% 2. Determining the RHS variable
Y_lag = [];
for j = 1:p
    Y_lag = [Y_lag, Y(p+1-j:T-j,:)];
end

% 3. OLS estimator
XX = Y_lag'*Y_lag;
XY = Y_lag'*Y0;
A_hat = XX\XY; % p*K by K

% 4. Variance-covariance Estimator
U_hat = Y0 - Y_lag*A_hat;
Sigma_hat = (U_hat'*U_hat) / (T1-p*K);

% 5. Companion Form
if p > 1
    F = [A_hat'; eye((p-1)*K), zeros(K*(p-1),K)]; % p*K by p*K
elseif p == 1
    F = A_hat';
end

% 6. Prediction
if H == 0
    Y_pred = [];
else
    Y_pred = zeros(H,K);
    Y_lag_pred = flip(Y0(end-p+1:end,:));
    FF = F;
    for h = 1:H
        Vec_Y_lag = vec(Y_lag_pred'); % RHS variables of prediction model
        Y_h = FF*Vec_Y_lag; % Fitted LHS of prediction model
        y_h = Y_h(1:K,1); % row of Y_h
        Y_pred(h,:) = y_h'; % h-th prediction value
        Y_lag_pred = [y_h'; Y_lag_pred(1:p-1,:)]; % updated lagged variables
        FF = FF*F; % updated coefficient
    end

    Y_pred = Y_pred + kron(ones(H,1), Y_'); % add mean of Y's
end

end