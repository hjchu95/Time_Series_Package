% =========================================================================
% DESCRIPTION
% This exercise generates a simulated data for a AR(p) model and compares
% the OLS and MLE estimates.

% -------------------------------------------------------------------------
% BREAKDOWN OF THE SCRIPT
% (1) Generate an AR(p) model with intercept.
% (2) Estimate the OLS estimator.
% (3) Estimate the MLE estimator using conditional MLE.
% (4) Display the results.

% -------------------------------------------------------------------------
% Written by Hyun Jae Stephen Chu
% 5, December, 2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Settings
clear;clc;
close all
rng(111)

addpath("/Users/hjchu/Library/CloudStorage/Dropbox/Codes/MATLAB/Time_Series")
addpath("TS_lib/")

%% DGP
tru_T = 250;
tru_mu = 0.5;
tru_a = [0.7;-0.3;0.1]; % AR(2) process
tru_sig2 = 0.5;

tru_p = rows(tru_a);

tru_Y = zeros(tru_T,1);
for t = 1:tru_T
    y_star = tru_mu + sqrt(tru_sig2)*randn(1);
    for i = 1:tru_p
        y_star = y_star + tru_a(i,1)*tru_Y(t+tru_p-i,1);
    end
    tru_Y(t+tru_p,1) = y_star;
end

tru_Y = tru_Y(tru_p+1:end,1);

tru_theta = [tru_mu;tru_a;tru_sig2];

%% Loading Data
y = tru_Y;
p = tru_p;

%% OLS Estimator
T = rows(y);

Y0 = y(p+1:end,:); % LHS variable
T1 = rows(Y0); % length of the AR(p) model

% 2. Determining the RHS variable
Y_lag = zeros(T1,p);
for j = 1:p
    Y_lag(:,j) = y(p+1-j:T-j,:);
end

X = [ones(T1,1),Y_lag];

% 3. Estimating the OLS estimator
XX = X' * X;
phi_hat = (XX)\(X'*Y0);

% 4. Estimating the variance-covariance matrix
y_hat = X*phi_hat;
u_hat = Y0 - y_hat;
sig2_hat = (u_hat'*u_hat) / (T1-p);

theta_OLS = [phi_hat;sig2_hat];

%% MLE
% <Step 1>: Initial parameters (Guess by OLS)
theta_init = [phi_hat',sig2_hat]';

% <Step 2>: Set objective function
objFun = @(theta) -1*arp_log_likelihood(theta,y,p);

options = optimset('Display', 'iter', 'MaxIter', 5000, 'MaxFunEvals', 5000);

% <Step 3>: Find Optimizer
[para,fval,exitflag] = fminsearch(objFun, theta_init, options);

theta_MLE = [para(1,1);flip(para(2:end-1));para(end)];

%% Display Results
index1 = [];
for i = 1:p
    index1 = [index1; ['AR_L',num2str(i)]];
end

maxlen = size(index1, 2);
mu_padded = ['mu', repmat(' ', 1, maxlen - length('mu'))];
sig2_padded = ['sig2', repmat(' ', 1, maxlen - length('sig2'))];
index1 = [mu_padded; index1; sig2_padded];

result_df = table(index1,tru_theta,theta_OLS,theta_MLE);
result_df.Properties.VariableNames = ["Index","True","OLS","MLE"];
disp(" ")
disp(result_df)

%% Plotting



%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Subfunctions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function [log_lik] = arp_log_likelihood(theta,y,p)

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

%%
function [log_lik] = arp_log_likelihood_exact(theta, y, p)
    % Load Parameters
    mu = theta(1);
    alpha = theta(2:end-1);
    sig2 = theta(end);
    
    % Ensure sig2 is positive
    if sig2 <= 0
        log_lik = -Inf;
        return;
    end
    
    % Total number of observations
    T = length(y);
    
    % Compute the covariance matrix of the initial observations
    % This involves solving the Yule-Walker equations to get the autocovariances
    % Then constructing the covariance matrix Vp
    % This is a complex step and requires careful implementation
    
    % For simplicity, let's assume the process is stationary and use theoretical moments
    % Compute autocovariances
    acov = zeros(p, 1);
    for k = 1:p
        acov(k) = sig2 * sum(alpha.^(abs(k)));
    end
    Vp = toeplitz(acov);
    
    % Initial observations likelihood
    Yp = y(1:p);
    mu_vec = mu * ones(p, 1);
    initial_log_lik = -0.5 * (p * log(2 * pi) + log(det(Vp)) + (Yp - mu_vec)' / Vp * (Yp - mu_vec));
    
    % Conditional likelihood
    u = zeros(T - p, 1);
    for t = (p + 1):T
        y_pred = mu + alpha' * y((t - p):(t - 1));
        u(t - p) = y(t) - y_pred;
    end
    cond_log_lik = -0.5 * ((T - p) * log(2 * pi * sig2) + sum(u .^ 2) / sig2);
    
    % Total log-likelihood
    log_lik = initial_log_lik + cond_log_lik;
end
