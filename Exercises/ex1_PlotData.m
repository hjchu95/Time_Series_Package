%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This exercise plots the macro data of Korea and the US.

% Written by Hyun Jae Stephen Chu
% July 4th, 2025
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 0. Settings
clear;clc;
close all
rng(123)

addpath("/Users/hjchu/Documents/GitHub/Time_Series_Package/Exercises")
addpath("/Users/hjchu/Documents/GitHub/Time_Series_Package/TS_lib")

%% 1. Loading Data
KOR_data = readmatrix("tsdata_20250704.xlsx",'Sheet','KOR','Range','B2:L102');
% 2000 Q1 ~ 2025 Q1
% NGDPSA, RGDPSA, NGDPNSA, RGDPNSA, GDPdef, CPI, ForEX, Call, CD91, GOV1Y, GOV3Y
US_data = readmatrix("tsdata_20250704.xlsx",'Sheet','US','Range','B2:N262');
% 1960 Q1 ~ 2025 Q1
% NGDPSA, NGDPNSA, RGDPSA, RGDPNSA, GDPDEF, PCE, CPI, PPI, FFE, T10Y,
% T10M3Y, UNEMP, WTI

%% 2. Comparing Seasonally Adjusted Data
% 2-(1) KOREA
kor_NGDPSA = KOR_data(:,1);
kor_NGDPNSA = KOR_data(:,3);
kor_RGDPSA = KOR_data(:,2);
kor_RGDPNSA = KOR_data(:,4);

f1 = figure('Position',[300 200 1100 600]);
subplot(2,1,1)
plot([kor_NGDPNSA, kor_NGDPSA], 'linewidth', 2)
max1 = max(max(kor_NGDPNSA), max(kor_NGDPSA));
min1 = min(min(kor_NGDPNSA), min(kor_NGDPSA));
if min1 < 0
    q = 1.1;
else
    q = 0.9;
end
axis([1 rows(kor_NGDPNSA) q*min1 1.1*max1])
xticks(1:20:rows(kor_NGDPNSA))
xticklabels({'2000','2005','2010','2015','2020','2025'})
title('KOR NGDP Seasonally Adjusted vs Not Seasonally Adjusted', 'fontsize', 20, 'interpreter', 'latex')
legend('KOR NGDPNSA', 'KOR NGDPSA', 'location', 'north')
grid on

subplot(2,1,2)
plot([kor_RGDPNSA, kor_RGDPSA], 'linewidth', 2)
max1 = max(max(kor_RGDPNSA), max(kor_RGDPSA));
min1 = min(min(kor_RGDPNSA), min(kor_RGDPSA));
if min1 < 0
    q = 1.1;
else
    q = 0.9;
end
axis([1 rows(kor_RGDPNSA) q*min1 1.1*max1])
xticks(1:20:rows(kor_RGDPNSA))
xticklabels({'2000','2005','2010','2015','2020','2025'})
title('KOR RGDP Seasonally Adjusted vs Not Seasonally Adjusted', 'fontsize', 20, 'interpreter', 'latex')
legend('KOR RGDPNSA', 'KOR RGDPSA', 'location', 'north')
grid on

% 2-(2) US
us_NGDPSA = US_data(:,1)./4; % Seasonally Adjusted Annualized Rate to Quarterly
us_NGDPNSA = US_data(:,2)*0.001; % millions of dollars to billions of dollars
us_RGDPSA = US_data(:,3)./4; % Seasonally Adjusted Annualized Rate to Quarterly
us_RGDPNSA = US_data(:,4);

f2 = figure('Position',[300 200 1100 600]);
subplot(2,1,1)
plot([us_NGDPNSA, us_NGDPSA], 'linewidth', 2)
max1 = max(max(us_NGDPNSA), max(us_NGDPSA));
min1 = min(min(us_NGDPNSA), min(us_NGDPSA));
if min1 < 0
    q = 1.1;
else
    q = 0.9;
end
axis([1 rows(us_NGDPNSA) q*min1 1.1*max1])
xticks(1:20:rows(us_NGDPNSA))
xticklabels({'1960','1965','1970','1975','1980','1985','1990','1995','2000','2005','2010','2015','2020','2025'})
title('US NGDP Seasonally Adjusted vs Not Seasonally Adjusted', 'fontsize', 20, 'interpreter', 'latex')
legend('US NGDPNSA', 'US NGDPSA', 'location', 'north')
grid on

subplot(2,1,2)
plot([us_RGDPNSA, us_RGDPSA], 'linewidth', 2)
max1 = max(max(us_RGDPNSA), max(us_RGDPSA));
min1 = min(min(us_RGDPNSA), min(us_RGDPSA));
if min1 < 0
    q = 1.1;
else
    q = 0.9;
end
axis([1 rows(us_RGDPNSA) q*min1 1.1*max1])
xticks(1:20:rows(us_RGDPNSA))
xticklabels({'1960','1965','1970','1975','1980','1985','1990','1995','2000','2005','2010','2015','2020','2025'})
title('US RGDP Seasonally Adjusted vs Not Seasonally Adjusted', 'fontsize', 20, 'interpreter', 'latex')
legend('US RGDPNSA', 'US RGDPSA', 'location', 'north')
grid on


%% 3. Comparing Nominal and Real GDP
f3 = figure('Position',[300 200 1100 600]);
subplot(2,1,1)
plot([kor_NGDPSA, kor_RGDPSA], 'linewidth', 2)
max1 = max(max(kor_NGDPSA), max(kor_RGDPSA));
min1 = min(min(kor_NGDPSA), min(kor_RGDPSA));
if min1 < 0
    q = 1.1;
else
    q = 0.9;
end
axis([1 rows(kor_NGDPSA) q*min1 1.1*max1])
xticks(1:20:rows(kor_NGDPSA))
xticklabels({'2000','2005','2010','2015','2020','2025'})
title('KOR NGDPSA vs RGDPSA', 'fontsize', 20, 'interpreter', 'latex')
legend('KOR NGDPSA', 'KOR RGDPSA', 'location', 'north')
grid on

subplot(2,1,2)
plot([us_NGDPSA, us_RGDPSA], 'linewidth', 2)
max1 = max(max(us_NGDPSA), max(us_RGDPSA));
min1 = min(min(us_NGDPSA), min(us_RGDPSA));
if min1 < 0
    q = 1.1;
else
    q = 0.9;
end
axis([1 rows(us_NGDPSA) q*min1 1.1*max1])
xticks(1:20:rows(us_NGDPSA))
xticklabels({'1960','1965','1970','1975','1980','1985','1990','1995','2000','2005','2010','2015','2020','2025'})
title('US NGDPSA vs RGDPSA', 'fontsize', 20, 'interpreter', 'latex')
legend('US NGDPSA', 'US RGDPSA', 'location', 'north')
grid on

% <Thoughts>
% Before 2017, Real GDP is larger than the Nominal GDP.
% This is because the Real GDP is derived by using the chain-weighted
% method where the base year is 2017.
% By chain-weighting, the goods and services prior to 2017 are weighted to
% match the value post-2017.
% As the pre-2017 economy has relatively cheaper and less productive
% structure, the real GDP weighted by the price of 2017 is over-weighted 
% and the pre-2017 real GDP is measured to be higher than that of the nominal GDP.

%% 4. Converting Variables

