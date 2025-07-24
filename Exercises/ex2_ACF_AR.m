%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This exercise plots the macro data of Korea and the US, computes the 
% autocovariance functions, and tests the autocorrelation functions
% (check if white noise)

% The critical value of the build-in function regarding the autocorrelation
% function is 2 standard error limits not 1.96.

% Written by Hyun Jae Stephen Chu
% 6, August, 2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 0. Settings
clear;clc;
close all
rng(123)

addpath("/Users/hjchu/Documents/GitHub/Time_Series_Package/Exercises")
addpath(genpath("/Users/hjchu/Documents/GitHub/Time_Series_Package/TS_lib"))

save_folder = 'ex2_results';

fig_option = struct( ...
    'width', 700, ...
    'height', 400, ...
    'margin', struct('t', 30, 'l', 5, 'r', 5, 'b', 0) ...
    );

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

%% Autocovariance of Variables
us_y = [us_growth,us_gdpdef_inf,us_pce_inf,us_cpi_inf,us_ffe,us_T10Y,us_unemp];
us_var_list = {'growth','gdpdefinf','pceinf','cpiinf','ffe','T10Y','unemp'};
ind_control = 4;
us_var = us_y(:,ind_control);

kor_y = [kor_growth,kor_gdpdef_inf,kor_cpi_inf,kor_forex_growth,kor_call,kor_cd,kor_gov1Y,kor_gov3Y,kor_unemp];
kor_var_list = {'growth', 'gdpdefinf','cpiinf','dforex','call','cd91','gov1','gov3','unemp'}';
ind_control = 1; % Use this as the control of choosing which variable to use
kor_var = kor_y(:,ind_control);

[acor1,bound1] = autocor(us_var,[],1);
f1 = gcf;
save_as_html(f1,save_folder,'figure1',fig_option)

[acor2,bound2] = autocor(us_y(:,1),[],1);
f2 = gcf;
save_as_html(f2,save_folder,'figure2',fig_option)

return

[acor3,bound3] = autocor(kor_var,[],1);

%% BP and LB Test
[BoxPierce1, pval_BP1, LjungBox1, pval_LB1, tb1] = WN_test(us_var);
[BoxPierce2, pval_BP2, LjungBox2, pval_LB2, tb2] = WN_test(kor_var);

return

%% AR OLS
p = 4;
H = 8;
[phi_hat, sig2_hat, F, Y0, Y_lag, y_hat, u_hat, Y_predm] = OLS_ARp(kor_var,p,H);
[phi_hat2, sig2_hat2, F2, Y02, Y_lag2, y_hat2, u_hat2, Y_predm2] = OLS_ARp(us_var,p,H);

%% AR MLE

