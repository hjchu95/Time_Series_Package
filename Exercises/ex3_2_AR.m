%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This exercise compares the LSE and MLE of the simulated data and the US
% macroeconomic data.

% Written by Hyun Jae Stephen Chu
% July 29th, 2025
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 0. Settings
clear;clc;
close all
rng(123)

addpath("/Users/hjchu/Documents/GitHub/Time_Series_Package/Exercises")
addpath(genpath("/Users/hjchu/Documents/GitHub/Time_Series_Package/TS_lib"))

%% 1. Simulating Data
tru_T = 250;
tru_mu = 0.5;
tru_a = [0.5;-0.2;0.1]; % AR(3) process
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

%% 2. AR OLS
y = tru_Y;
p = tru_p;

[phi_hat, sig2_hat, F, Y0, Y_lag, y_hat, u_hat, Y_predm] = OLS_ARp(y,p);

mu_hat = meanc(y)*(1-sumc(phi_hat));
theta_OLS = [mu_hat;phi_hat;sig2_hat];

%% 3. AR MLE
option = 1;
[theta_MLE] = MLE_ARp(y,p);

%% 4. Display Results
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

return

%% 1. Loading Data
KOR_data = readmatrix("tsdata_20250704.xlsx",'Sheet','KOR','Range','B2:M102');
% 2000 Q1 ~ 2025 Q1
% NGDPSA, RGDPSA, NGDPNSA, RGDPNSA, GDPdef, CPI, ForEX, Call, CD91, GOV1Y,
% GOV3Y,Unemp
US_data = readmatrix("tsdata_20250704.xlsx",'Sheet','US','Range','B2:O262');
% 1960 Q1 ~ 2025 Q1
% NGDPSA, NGDPNSA, RGDPSA, RGDPNSA, GDPDEF, PCE, CPI, PPI, FFE, T10Y,
% T10M3Y, UNEMP, WTI

%% 2. Converting Variables
% (1) US
us_NGDPSA = US_data(:,1)./4; % Seasonally Adjusted Annualized Rate to Quarterly
us_RGDPSA = US_data(:,3)./4; % Seasonally Adjusted Annualized Rate to Quarterly

us_change = [us_RGDPSA,US_data(:,5:7)];
us_int = US_data(2:end,9:12);
us_unemp = US_data(2:end,13);
WTI = US_data(2:end,14);

us_y_inf = ts_diff(us_change,'qoq_gr');

us_growth = us_y_inf(:,1);
us_gdpdef_inf = us_y_inf(:,2);
us_pce_inf = us_y_inf(:,3);
us_cpi_inf = us_y_inf(:,4);
us_ffe = us_int(:,1);
us_T10Y = us_int(:,2);
% 1960 Q2 - 2025 Q1

% (2) Korea
kor_change = [KOR_data(:,2),KOR_data(:,5),KOR_data(:,6),KOR_data(:,7)];
kor_int = KOR_data(2:end,8:end-1);
kor_unemp = KOR_data(2:end,end);

kor_y_inf = ts_diff(kor_change,'qoq_gr');

kor_growth = kor_y_inf(:,1);
kor_gdpdef_inf = kor_y_inf(:,2);
kor_cpi_inf = kor_y_inf(:,3);
kor_forex_growth = kor_y_inf(:,4);
kor_call = kor_int(:,1);
kor_cd = kor_int(:,2);
kor_gov1Y = kor_int(:,3);
kor_gov3Y = kor_int(:,4);
% 1960 Q2 - 2025 Q1

%% 3. AR OLS
p = 4;
H = 8;
% [phi_hat, sig2_hat, F, Y0, Y_lag, y_hat, u_hat, Y_predm] = OLS_ARp(kor_var,p,H);
[phi_hat2, sig2_hat2, F2, Y02, Y_lag2, y_hat2, u_hat2, Y_predm2] = OLS_ARp(us_var,p,H);

%% 4. AR MLE
