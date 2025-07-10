%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This exercise plots the macro data of Korea and the US, computes the 
% autocovariance functions, and tests the autocorrelation functions
% (check if white noise)

% The critical value of the build-in function regarding the autocorrelation
% function is 2 standard error limits not 1.96.

% Written by Hyun Jae Stephen Chu
% 6, August, 2024
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
% rGDP, GDPDEF, PCE, FFE, T10Y

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

%% Plot Figures
figure(1)
subplot(3,1,1)
plot([kor_growth, kor_inf], 'linewidth', 2)
max1 = max(max(kor_growth), max(kor_inf));
min1 = min(min(kor_growth), min(kor_inf));
if min1 < 0
    q = 1.1;
else
    q = 0.9;
end
axis([1 rows(kor_growth) q*min1 1.1*max1])
xticks(1:20:rows(kor_growth))
xticklabels({'2001','2006','2011','2016','2021'})
title('Time Series of Macro Variables (KOR)', 'fontsize', 20, 'interpreter', 'latex')
legend('Growth', 'Inflation', 'location', 'northeast')
grid on

subplot(3,1,2)
plot(kor_forex, '-k', 'linewidth', 2)
max2 = max(kor_forex);
min2 = min(kor_forex);
if min2 < 0
    q = 1.1;
else
    q = 0.9;
end
axis([1 rows(kor_forex) q*min2 1.1*max2])
xticks(1:20:rows(kor_forex))
xticklabels({'2001','2006','2011','2016','2021'})
legend('KRW/USD', 'location', 'northeast')
grid on

subplot(3,1,3)
plot([kor_cd, kor_gov1Y, kor_gov3Y], 'linewidth', 2)
max3 = max([max(kor_cd), max(kor_gov1Y), max(kor_gov3Y)]);
min3 = min([min(kor_cd), min(kor_gov1Y), min(kor_gov3Y)]);
if min3 < 0
    q = 1.1;
else
    q = 0.9;
end
axis([1 rows(kor_cd) q*min3 1.1*max3])
xticks(1:20:rows(kor_cd))
xticklabels({'2001','2006','2011','2016','2021'})
legend('CD91', 'Gov1', 'Gov3', 'location', 'northeast')
grid on

figure(2)
subplot(3,1,1)
plot(us_growth, 'linewidth', 2)
max1 = max(us_growth);
min1 = min(us_growth);
if min1 < 0
    q = 1.1;
else
    q = 0.9;
end
axis([1 rows(us_growth) q*min1 1.1*max1])
xticks(4:20:rows(us_growth))
xticklabels({'1961','1966','1971','1976','1981','1986','1991','1996','2001','2006','2011','2016','2021'})
title('Time Series of Macro Variables (US)', 'fontsize', 20, 'interpreter', 'latex')
legend('Growth', 'location', 'northeast')
grid on

subplot(3,1,2)
plot([us_inf_def,us_inf_pce],'linewidth',2)
max1 = max(max(us_inf_def), max(us_inf_pce));
min1 = min(min(us_inf_def), min(us_inf_pce));
if min1 < 0
    q = 1.1;
else
    q = 0.9;
end
axis([1 rows(us_inf_def) q*min1 1.1*max1])
xticks(4:20:rows(us_inf_def))
xticklabels({'1961','1966','1971','1976','1981','1986','1991','1996','2001','2006','2011','2016','2021'})
title('Time Series of Macro Variables (US)', 'fontsize', 20, 'interpreter', 'latex')
legend('GDPDEF Inflation', 'PCE Inflation', 'location', 'northeast')
grid on

subplot(3,1,3)
plot([us_ffe, us_T10Y], 'linewidth', 2)
max2 = max(max(us_ffe), max(us_T10Y));
min2 = min(min(us_ffe), min(us_T10Y));
if min2 < 0
    q = 1.1;
else
    q = 0.9;
end
axis([1 rows(us_ffe) q*min2 1.1*max2])

xticks(4:20:rows(us_growth))
xticklabels({'1961','1966','1971','1976','1981','1986','1991','1996','2001','2006','2011','2016','2021'})
legend('FFE', 'T10Y', 'location', 'northeast')
grid on

%% Autocovariance of Variables
kor_y = [kor_growth, kor_inf, kor_forex, kor_cd, kor_gov1Y, kor_gov3Y];
kor_var_list = {'Growth', 'Inflation', 'Forex', 'CD', 'Gov1', 'Gov3'}';
ind_control = 1; % Use this as the control of choosing which variable to use
kor_var = kor_y(:,ind_control);

us_y = [us_growth,us_inf_def,us_inf_pce,us_ffe,us_T10Y];
us_var_list = {'Growth','GDPDEF Inflation', 'PCE Inflation','FFE','T10Y'};
ind_control = 2;
us_var = us_y(:,ind_control);

[autocor1, bound1] = autocor(kor_var);
[autocor2, bound2] = autocor(us_var);

[BoxPierce1, pval_BP1, LjungBox1, pval_LB1, tb1] = WN_test(kor_var);
[BoxPierce2, pval_BP2, LjungBox2, pval_LB2, tb2] = WN_test(us_var);

%% AR OLS
p = 4;
H = 8;
[phi_hat, sig2_hat, F, Y0, Y_lag, y_hat, u_hat, Y_predm] = OLS_ARp(kor_var,p,H);
[phi_hat2, sig2_hat2, F2, Y02, Y_lag2, y_hat2, u_hat2, Y_predm2] = OLS_ARp(us_var,p,H);

%% AR MLE

