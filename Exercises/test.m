%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Comparing prediction with Demeaned data without intercept and original 
% data with intercept

% Written by Hyun Jae Stephen Chu
% July 24th, 2025
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Setting
clear;clc;
close all
rng(123)

addpath("/Users/hjchu/Documents/GitHub/Time_Series_Package/Exercises")
addpath(genpath("/Users/hjchu/Documents/GitHub/Time_Series_Package/TS_lib"))

%% Simulated Data
tru_mu = 1.5;
tru_beta = [0.8;0.001;0.3;-0.05];

% Method 1: Root of characteristic polynomial (in z)
poly_coef = fliplr([1, -tru_beta(:)']);
rts = roots(poly_coef);
if all(abs(rts) > 1)
    disp("Stationary (by roots)");
else
    disp("Nonstationary (by roots)");
end

% Method 2: Eigenvalues of companion matrix (lambda = 1/z)
F = [tru_beta'; eye(3), zeros(3,1)];
eigF = eig(F);
if max(abs(eigF)) < 1
    disp("Stationary (by companion matrix)");
else
    disp("Nonstationary (by companion matrix)");
end

return

tru_sig2 = 0.2;
tru_T = 10000;
tru_p = rows(tru_beta);

burnin = 1000;

tru_Y = zeros(tru_T+tru_p+burnin,1);
for t = tru_p+1:tru_T+tru_p+burnin
    tru_Y(t,1) = tru_mu + tru_beta(1)*tru_Y(t-1,1) + tru_beta(2)*tru_Y(t-2,1) + tru_beta(3)*tru_Y(t-3,1) + tru_beta(4)*tru_Y(t-4,1) + sqrt(tru_sig2)*randn(1,1);
end

tru_Y = tru_Y(burnin+tru_p+1:end,:);

Y_ = tru_mu / (1-sum(tru_beta));
hatY_ = meanc(tru_Y);