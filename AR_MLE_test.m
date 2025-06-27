%% Settings
clear;clc;

%% DGP
% Simulate an AR(2) process
T = 500;
a_true = [0.6; -0.3];
sigma2_true = 0.5;
mu_true = 0;

e = sqrt(sigma2_true) * randn(T,1);
X = zeros(T,1);
X(1:2) = randn(2,1); % Initial values
for t = 3:T
    X(t) = mu_true + a_true(1)*X(t-1) + a_true(2)*X(t-2) + e(t);
end

p = 2; % Order of the AR model

% Initial parameter guesses (transformed)
mu0 = mean(X);
pacf0 = zeros(p,1); % Initial guess for PACF parameters
phi_trans0 = atanh(pacf0); % Inverse hyperbolic tangent transformation
logsigma2_0 = -log(var(X));

theta0_trans = [mu0; phi_trans0; logsigma2_0];

% Objective function handle
objFun = @(theta_trans) arp_negloglik_transformed(theta_trans, X, p);

% Optimization options
options = optimset('Display', 'iter', 'MaxIter', 5000, 'MaxFunEvals', 10000);

% Run optimization
[theta_hat_trans, fval, exitflag, output] = fminsearch(objFun, theta0_trans, options);

% Transform back to original parameters
mu_hat = theta_hat_trans(1);
pacf_hat = tanh(theta_hat_trans(2:p+1));
a_hat = pacf_to_ar(pacf_hat);
sigma2_hat = exp(theta_hat_trans(p+2));

% Display results
disp('Estimated Parameters:');
disp(['mu_hat = ', num2str(mu_hat)]);
disp(['a_hat = ', num2str(a_hat')]);
disp(['sigma2_hat = ', num2str(sigma2_hat)]);

disp('True Parameters:');
disp(['mu_true = ', num2str(mu_true)]);
disp(['a_true = ', num2str(a_true')]);
disp(['sigma2_true = ', num2str(sigma2_true)]);

%%
function negLogLik = arp_negloglik_transformed(theta_trans, X, p)
    % arp_negloglik_transformed computes the negative log-likelihood of an AR(p) process
    %
    % Inputs:
    %   - theta_trans: Transformed parameters [mu; phi_trans; logsigma2]
    %   - X: Time series data (column vector)
    %   - p: Order of the AR process
    %
    % Output:
    %   - negLogLik: Negative log-likelihood value

    % Extract transformed parameters
    mu = theta_trans(1);
    phi_trans = theta_trans(2:p+1);
    logsigma2 = theta_trans(p+2);

    % Transform parameters back to original space
    sigma2 = exp(logsigma2); % Ensures sigma2 > 0

    % Transform PACF parameters back to original scale using tanh
    pacf = tanh(phi_trans); % Ensures each |pacf_i| < 1

    % Convert PACF to AR coefficients
    a = pacf_to_ar(pacf);

    % Check stationarity (roots outside unit circle)
    % if ~isstable(a)
    %     negLogLik = Inf;
    %     return;
    % end

    T = length(X);

    % Compute mean m
    denom = 1 - sum(a);
    if denom == 0
        negLogLik = Inf;
        return;
    end
    m = mu / denom;

    % Compute initial observations likelihood
    Xp = X(1:p);
    Xp_centered = Xp - m;

    % Compute covariance matrix Vp for initial observations
    gamma = autocovariance_ARp(a, sigma2, p);
    Vp = toeplitz(gamma(1:p));

    % Check if Vp is positive definite
    [~, pdef] = chol(Vp);
    if pdef ~= 0
        negLogLik = Inf;
        return;
    end

    % Initial observations log-likelihood
    logDetVp = sum(log(diag(chol(Vp))));
    invVp = inv(Vp);
    initialLogLik = - (p/2)*log(2*pi) - logDetVp - 0.5 * (Xp_centered') * invVp * Xp_centered;

    % Compute conditional log-likelihood
    residuals = zeros(T - p, 1);
    for t = p+1:T
        X_pred = mu + a' * X(t-1:-1:t-p);
        residuals(t-p) = X(t) - X_pred;
    end
    condLogLik = - ((T - p)/2)*log(2*pi*sigma2) - (0.5 / sigma2) * sum(residuals.^2);

    % Total negative log-likelihood
    negLogLik = - (initialLogLik + condLogLik);
end

%%
function a = pacf_to_ar(pacf)
    p = length(pacf);
    a = zeros(p,1);
    for k = 1:p
        a_k = pacf(k);
        if k > 1
            a_prev = a(1:k-1);
            a(1:k-1) = a_prev - a_k * flipud(a_prev);
        end
        a(k) = a_k;
    end
end

%%
function stable = isstable(a)
    % Construct the characteristic polynomial
    poly_coeffs = [1; -a];
    roots_poly = roots(poly_coeffs);
    % Check if all roots lie outside the unit circle
    stable = all(abs(roots_poly) > 1);
end

