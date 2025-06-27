function [phi_hat, sig2_hat, F, Y0, Y_lag, y_hat, u_hat, Y_predm] = OLS_ARp(y,p,h)
% =========================================================================
% DESCRIPTION
% Esimation of the AR(p) Model

% -------------------------------------------------------------------------
% INPUT AND OUTPUTS
% Args:
%   y: Objective of estimation (univariate)
%   p: Lag of AR(p) model
%   H: Maximum forecasting horizon, does not forecast if None

% Returns:
%   phi_hat: OLS estimator
%   Omega_hat: Variance-covariance matrix estimator
%   F: Companion form of OLS estimators
%   Y0: Response variable used in estimation
%   Y_lag: Explanatory variable used in estimation
%   Y_predm: Predicted value

% -------------------------------------------------------------------------
% NOTES
% - Variables are demeaned to not consider the intercept term for simplicity
% - The eliminated mean must later be added back to the demeaned variables,
%   the fitted and predicted value.

% -------------------------------------------------------------------------
% Written by Hyun Jae Stephen Chu
% August 7th, 2024
% =========================================================================

if nargin == 3
    H = h;
else
    H = 0;
end

% 1. Demeaning variable and determining the LHS variable
Y_ = meanc(y); % mean saved for prediction
Y = demeanc(y);
T = rows(Y);

Y0 = Y(p+1:end,:); % LHS variable
T1 = rows(Y0); % length of the AR(p) model

% 2. Determining the RHS variable
Y_lag = zeros(T1,p);
for j = 1:p
    Y_lag(:,j) = Y(p+1-j:T-j,:);
end

% 3. Estimating the OLS estimator
XX = Y_lag' * Y_lag;
phi_hat = (XX)\(Y_lag'*Y0);

% 4. Estimating the variance-covariance matrix
y_hat = Y_lag*phi_hat;
u_hat = Y0 - y_hat;
sig2_hat = (u_hat'*u_hat) / (T1-p);

varbhat = diag(ones(p,1)*sig2_hat)/(XX); % variance of bhat
stde = sqrt(diag(varbhat)); % standard error
b0 = zeros(p,1); % null hypothesis
t_val = (phi_hat - b0) ./ stde;
p_val = 2*(1-normcdf(abs(t_val),0,1));

% 5. Companion Form
if p > 1
  F = [phi_hat'; eye(p-1), zeros(p-1,1)];  % p*k by p*k
elseif p==1
  F = phi_hat';
end

% 6. Prediction
if H == 0
    Y_predm = [];
else
    Y_predm = zeros(H,1);
    Y_lag = flip(Y0(end-p+1:end,:));
    FF = F;
    for h = 1:H
        Y_h = FF*Y_lag;
        y_h = Y_h(1,1);
        Y_predm(h,:) = y_h;
        Y_lag = [y_h; Y_lag(1:p-1,:)];
        FF = FF*F;
    end

    Y_predm = Y_predm + ones(H,1) * Y_;
end

% 7. Make result table
index1 = [];
for i = 1:p
    index1 = [index1; ['AR_L',num2str(i)]];
end
result_df = table(index1,phi_hat,stde,t_val,p_val);
result_df.Properties.VariableNames = ["Index","Coefficents","S.E.","t-value","p-value"];
disp(" ")
disp(result_df)
if H == 0
    index2 = NaN;
    y_predm = NaN;
else
    index2 = [];
    for j = 1:H
        index2 = [index2; ['H = ',num2str(j)]];
    end
    y_predm = Y_predm;
end
pred_df = table(index2,y_predm);
pred_df.Properties.VariableNames = ["Horizon","Predicted"];
disp(" ")
s1 = sprintf("Predicted value for H = %4d is", H);
disp(s1)
disp(" ")
disp(pred_df)

% 8. Plotting
Y0 = Y0 + ones(T1,1)*Y_; % response variable
y_hat = y_hat + ones(T1,1)*Y_; % fitted value

ymax = max(max(max(Y0), max(y_hat)));
ymin = min(min(min(Y0), min(y_hat)));
umax = max(u_hat);
umin = min(u_hat);

if ymin > 0 && ymin > 1
    weight = 0.9;
elseif (0 < ymin) && (ymin < 1)
    weight = -0.5;
else
    weight = 1.1;
end

f1 = figure;
f1.Position(1) = f1.Position(1)*0.8;
f1.Position(2) = f1.Position(2)*0.8;
f1.Position(3) = f1.Position(3)*1.5;
f1.Position(4) = f1.Position(4)*1.2;
yyaxis left
plot((1:rows(Y0)), Y0, '-k', (1:rows(y_hat)), y_hat, '-b', 'LineWidth', 1.5);
if weight > 0
    axis([0 rows(Y0) ymin*weight ymax*1.1])
else
    axis([0 rows(Y0) ymin+weight ymax*1.1])
end

yyaxis right
plot((1:rows(u_hat)), u_hat, '--r', 'LineWidth', 1.5);
title("Plot of Data, Fitted Value and Residual",'FontSize',20,'interpreter','latex')
axis([0 rows(u_hat) umin*1.1 umax*1.1])
legend({'Data','Fitted','Residual'})
grid on

if H ~= 0
    f2 = figure;
    f2.Position(1) = f2.Position(1)*0.8-20;
    f2.Position(2) = f2.Position(2)*0.8-20;
    f2.Position(3) = f2.Position(3)*1.5-20;
    f2.Position(4) = f2.Position(4)*1.2-20;
    Y_H = [Y0; Y_predm];
    yhmax = max(Y_H);
    yhmin = min(Y_H);
    if yhmin > 0 && yhmin > 1
        weight1 = 0.9;
    elseif (0 < yhmin) && (yhmin < 1)
        weight1 = -0.5;
    else
        weight1 = 1.1;
    end
    
    plot((1:rows(Y0)), Y0, '-k', 'LineWidth', 1.5)
    title("Plot of Data and Predicted Value", 'FontSize', 20, 'Interpreter', 'latex')
    if weight1 > 0
        axis([0 rows(Y_H) yhmin*weight1 yhmax*1.1])
    else
        axis([0 rows(Y_H) yhmin+weight1 yhmax*1.1])
    end
    hold on
    plot((rows(Y0)+1:rows(Y_H)), Y_predm, '--r', 'LineWidth', 1.5)
    legend({'Data','Predict'})
    grid on

end