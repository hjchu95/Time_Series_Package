function [Theta, CILv, CIHv] = VAR_IRF_Boot(y, p, H, restrict, N, quant)
% =========================================================================
% DESCRIPTION
% Estimate the Impulse-response function of a structural-form VAR(p) model
% with confidence intervals obtained by Bootstrapping 

% -------------------------------------------------------------------------
% INPUT AND OUTPUTS
% Args:
%   y: Response variable matrix of VAR(p) model (multivariate)
%   p: Optimal lag of VAR(p) model
%   H: Maximum forecasting horizon considered to derive the
%       impulse-response function
%   restrict: Identification method to use
%       (1) short = Short-run, recursive restriction
%       (2) long = Long-run restriction
%   N: Number of iteration for Bootstrapping
%   quant: Quantile of confidence interval for the impulse-response function
%   (default = 90, 90% confidence interval)

% Returns:
%   Theta: Estimated impulse-response function of the VAR(p) model
%   CILv: Lower bound of the confidence interval for the impulse-response
%   function
%   CIHv: Upper bound of the confidence interval for the impulse-response
%   function

% -------------------------------------------------------------------------
% STEPS
%   <Step 1>: Estimate Reduced-form VAR (with demean)
%   <Step 2>: Obtain B0inv by chosen restriction (short or long-run)
%   <Step 3>: Obtain new set of error
%   <Step 4>: Obtain bootstrap sample and re-estimate the parameters
%   <Step 5>: Compute the IRF
%   <Step 6>: Obtain the quantiles

% -------------------------------------------------------------------------
% NOTES
% - Variables are demeaned to not consider the intercept term for simplicity
% - The eliminated mean must later be added back to the demeaned variables,
%   the fitted and predicted value.

% -------------------------------------------------------------------------
% Written by Hyun Jae Stephen Chu
% March 30th, 2025
% =========================================================================
% [[Preprocess: Obtain OLS estimators and identify structural-form]]
% <Step 1>: Estimate Reduced-form VAR(p) (with demean)
Y_ = meanc(y);
Y = demeanc(y);
[A_hat,Sigma_hat,F,Y0,Y_lag,u_hat,Y_pred] = OLS_VAR(Y,p);

% <Step 2>: Obtain B0inv by restriction type
B0inv = B0invSolve(A_hat,Sigma_hat,restrict);

% [[Initial IRF]]
Theta = irf_estimate(F,p,H,B0inv);

% [[Obtain Confidence Interval of IRF by Bootstrapping]]
if isempty(N)
    n = 2000; % default is 2000 iterations for bootstrapping
else
    n = N; % or else run the inputted number of iterations
end

[T,K] = size(y); % T by K
IRFm = zeros(n,K^2*(H+1)); % to store IRFs over iterations

for iter = 1:n

    % <Step 3>: Obtain a new set of residuals
    indu = 1:T-p; % 1 by T-p (row vector)
    indu = indu'; % T-p by 1 (column vector)
    indu = rndper(indu); % randomly permute residuals

    ustar = u_hat(indu,:); % new set of residuals

    ystar = zeros(T,K);
    ind_ystar = fix(rand(1,1)*(T-p+1))+1; % starting point of p consecutive observations of y
    ystar(1:p,:) = Y(ind_ystar:ind_ystar+p-1,:); % select p consecutive observations of initial y

    % <Step 4>: Obtain the Bootstrap sample
    for it = p+1:T
        ystar(it,:) = ustar(it-p,:);
        for jt = 1:p
            ystar(it,:) = ystar(it,:) + ystar(it-jt,:)*A_hat((jt-1)*K+1:jt*K,:);
        end
    end
    
    [A_star,Sigma_star,F_star,~,~,u_star,~] = OLS_VAR(ystar,p); % re-estimate parameters
    B0inv_star = B0invSolve(A_star,Sigma_star,restrict); % re-identify B0 inverse

    % <Step 5>: Compute the Impulse Response Function(IRF)
    [IRFboot] = irf_estimate(F_star,p,H,B0inv_star);
    IRFm(iter,:) = vec(IRFboot')'; % store new IRF

end

% <Step 6>: Obtain Quantiles
if isempty(quant)
    qt = [5 95]; % default quantile is 90%
    qt_name = '90';
else
    qt = quant;
    qt_name = num2str(qt(2)-qt(1));
end

CIv = prctile(IRFm, qt); % qt percentile of IRFm, 2 by (H+1)*(K^2)
CILv = reshape(CIv(1,:)',H+1,K^2)'; % lower bound
CIHv = reshape(CIv(2,:)',H+1,K^2)'; % upper bound

% [[Plot the results]]
name = [];
for indvari = 1:K
    for indshock = 1:K
        temp = ['e_',num2str(indshock) '\rightarrow y_' num2str(indvari)];
        name = [name;temp];
    end
end

figure
for i = 1:K^2
    subplot(K,K,i)
    plot((0:H),Theta(i,:),'-k',(0:H),CIHv(i,:),'-.b',(0:H),CILv(i,:),'-.b',(0:H),zeros(H+1,1),'-r','linewidth',1.5)
    xlim([0 H])
    title(name(i,:))
end
legend('IRF',[qt_name,'% CI']);

end