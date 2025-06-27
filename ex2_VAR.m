% =========================================================================
% DESCRIPTION
% This exercise 
% (1) estimates the optimal order of a VAR(p) model
% (2) estimates parameters of a reduced-form VAR(p) model
% (3) estimates the impulse response function of a structural-form VAR(p) 
%     model using the bootstrap-after-bootstrap method of Kilian (1998) by
%   (i) short-run restrictions
%   (ii) long-run restrictions
%   (iii) sign-restrictions
% (4) estimates the forecast error variance decomposition
% (5) estimates the historical decomposition

% -------------------------------------------------------------------------
% SUBFUNCTIONS
% 

% -------------------------------------------------------------------------
% Written by Hyun Jae Stephen Chu
% August 9th, 2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Settings
clear;clc;
close all
rng(123)

addpath("/Users/hjchu/Library/CloudStorage/Dropbox/Codes/MATLAB/Time_Series")
addpath("/Users/hjchu/Library/CloudStorage/Dropbox/Codes/MATLAB/Time_Series/TS_lib")

%% Loading Data
KOR_data = readmatrix("tsdata_20250322.xlsx",'Sheet','KOR','Range','B2:G101');
% 2000 Q1 ~ 2024 Q2
% rGDP, CPI, FOREX, CD91, GOV1Y, GOV3Y
US_data = readmatrix("tsdata_20250322.xlsx",'Sheet','US','Range','B2:F261');
% 1960 Q1 ~ 2024 Q2
% rGDP, PCE, FFE, T10Y

[T,~] = size(KOR_data);

kor_growth = zeros(T-4,1);
kor_inf = zeros(T-4,1);
for t = 1:T-4
    kor_growth(t,1) = log(KOR_data(t+4,1)) - log(KOR_data(t,1));
    kor_inf(t,1) = log(KOR_data(t+4,2)) - log(KOR_data(t,2));
end
kor_growth = kor_growth*100;
kor_inf = kor_inf*100;
kor_forex = KOR_data(5:end,3);
kor_cd = KOR_data(5:end,4);
kor_gov1Y = KOR_data(5:end,5);
kor_gov3Y = KOR_data(5:end,6);
% 2001 Q1 ~ 2024 Q4

[T,~] = size(US_data);
us_growth = zeros(T-1,1);
us_inf_def = zeros(T-1,1);
us_inf_pce = zeros(T-1,1);
for t = 1:T-1
    us_growth(t,1) = log(US_data(t+1,1)) - log(US_data(t,1));
    us_inf_def(t,1) = log(US_data(t+1,2)) - log(US_data(t,2));
    us_inf_pce(t,1) = log(US_data(t+1,3)) - log(US_data(t,3));
end
us_growth = us_growth*100;
us_inf_def = us_inf_def*100;
us_inf_pce = us_inf_pce*100;
us_ffe = US_data(2:end,4);
us_T10Y = US_data(2:end,5);
% 1960 Q2 ~ 2024 Q4

%% 3. Estimating Optimal Order of VAR(p)
y = [kor_inf,kor_growth,kor_cd];
pmax = 4;

[p_seq,p_aic,p_bic,p_hq] = orderVAR(y,pmax);

%% 4. Estimating Reduced-form VAR(p)
H = 4;
[A_hat, Sigma_hat, F, Y0, Y_lag, U_hat, Y_pred] = OLS_VAR(y, p_bic, H);

%% 5. Identifying Structural-form VAR(p)
restrict = 'short';
H = 20;
[Theta, CILv, CIHv] = VAR_IRF_Boot(y, p_bic, H, restrict,[],[]);