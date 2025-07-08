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
addpath(genpath("/Users/hjchu/Documents/GitHub/Time_Series_Package/TS_lib"))

kor_xtick_labels1 = {'2000','2005','2010','2015','2020','2025'};
kor_xtick_labels2 = {'2001','2006','2011','2016','2021'};
us_xtick_labels1 = {'1960','1965','1970','1975','1980','1985','1990','1995','2000','2005','2010','2015','2020','2025'};
us_xtick_labels2 = {'1961','1966','1971','1976','1981','1986','1991','1996','2001','2006','2011','2016','2021'};

save_folder = 'ex1_results';

%% 1. Loading Data
KOR_data = readmatrix("tsdata_20250704.xlsx",'Sheet','KOR','Range','B2:M102');
% 2000 Q1 ~ 2025 Q1
% NGDPSA, RGDPSA, NGDPNSA, RGDPNSA, GDPdef, CPI, ForEX, Call, CD91, GOV1Y, GOV3Y
US_data = readmatrix("tsdata_20250704.xlsx",'Sheet','US','Range','B2:O262');
% 1960 Q1 ~ 2025 Q1
% NGDPSA, NGDPNSA, RGDPSA, RGDPNSA, GDPDEF, PCE, CPI, PPI, FFE, T10Y,
% T10M3Y, UNEMP, WTI

%% 2. Comparing Seasonally Adjusted Data
% 2-(1) KOREA
kor_NGDPSA = KOR_data(:,1);
kor_NGDPNSA = KOR_data(:,3);
kor_RGDPSA = KOR_data(:,2);
kor_RGDPNSA = KOR_data(:,4);

kor_T = rows(kor_NGDPNSA);

f1 = figure('Position',[300 200 1100 600]);
plot_time_series([kor_NGDPNSA,kor_NGDPSA], ...
    1:20:kor_T,kor_xtick_labels1, ...
    'KOR NGDP Seasonally Adjusted vs Not Seasonally Adjusted', ...
    {'KOR NGDPNSA', 'KOR NGDPSA'}, 1)
save_as_html(f1,save_folder,'figure1a')

f2 = figure('Position',[300 200 1100 600]);
plot_time_series([kor_RGDPNSA, kor_RGDPSA], ...
    1:20:kor_T,kor_xtick_labels1, ...
    'KOR RGDP Seasonally Adjusted vs Not Seasonally Adjusted', ...
    {'KOR RGDPNSA', 'KOR RGDPSA'}, 1)
save_as_html(f2,save_folder,'figure1b')

return

% 2-(2) US
us_NGDPSA = US_data(:,1)./4; % Seasonally Adjusted Annualized Rate to Quarterly
us_NGDPNSA = US_data(:,2)*0.001; % millions of dollars to billions of dollars
us_RGDPSA = US_data(:,3)./4; % Seasonally Adjusted Annualized Rate to Quarterly
us_RGDPNSA = US_data(:,4);

us_T = rows(us_NGDPNSA);

f2 = figure('Position',[300 200 1100 600]);
subplot(2,1,1)
plot_time_series([us_NGDPNSA, us_NGDPSA], ...
    1:20:us_T,us_xtick_labels1, ...
    'US NGDP Seasonally Adjusted vs Not Seasonally Adjusted', ...
    {'US NGDPNSA', 'US NGDPSA'}, 1)

subplot(2,1,2)
plot_time_series([us_RGDPNSA, us_RGDPSA], ...
    1:20:us_T,us_xtick_labels1, ...
    'US RGDP Seasonally Adjusted vs Not Seasonally Adjusted', ...
    {'US RGDPNSA', 'US RGDPSA'}, 1)

%% 3. Comparing Nominal and Real GDP
f3 = figure('Position',[300 200 1100 600]);
subplot(2,1,1)
plot_time_series([kor_NGDPSA, kor_RGDPSA], ...
    1:20:kor_T,kor_xtick_labels1, ...
    'KOR NGDPSA vs RGDPSA', ...
    {'KOR NGDPSA', 'KOR RGDPSA'}, 1)

subplot(2,1,2)
plot_time_series([us_NGDPSA, us_RGDPSA], ...
    1:20:us_T,us_xtick_labels1, ...
    'US NGDPSA vs RGDPSA', ...
    {'US NGDPSA', 'US RGDPSA'}, 1)

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
kor_change = [KOR_data(:,2),KOR_data(:,5),KOR_data(:,6)];
kor_forex = KOR_data(5:end,7);
kor_int = KOR_data(5:end,8:end-1);
kor_unemp = KOR_data(5:end,end);

kor_y_inf = pc_diff(kor_change,1);

us_change = [US_data(:,3),US_data(:,5:8)];
us_int = US_data(2:end,9:12);
us_unemp = US_data(2:end,13);
WTI = US_data(2:end,14);

us_y_inf = pc_diff(us_change,2);

%% 5. Comparing Price Index and Inflation Rate
kor_gdpdef = KOR_data(:,5);
kor_cpi = KOR_data(:,6);
kor_gdpdef_inf = kor_y_inf(:,2);
kor_cpi_inf = kor_y_inf(:,3);

dkor_T = rows(kor_gdpdef_inf);

us_gdpdef = US_data(:,5);
us_pce = US_data(:,6);
us_cpi = US_data(:,7);
us_ppi = US_data(:,8);
us_gdpdef_inf = us_y_inf(:,2);
us_pce_inf = us_y_inf(:,3);
us_cpi_inf = us_y_inf(:,4);
us_ppi_inf = us_y_inf(:,5);

dus_T = rows(us_gdpdef_inf);

f4 = figure('Position',[300 200 1100 600]);
subplot(2,1,1)
plot_time_series([kor_gdpdef,kor_cpi], ...
    1:20:kor_T,kor_xtick_labels1, ...
    'Price Indices (KOREA)', ...
    {'KOR GDPDEF', 'KOR CPI'}, 1)

subplot(2,1,2)
plot_time_series([kor_gdpdef_inf, kor_cpi_inf], ...
    1:20:dkor_T, kor_xtick_labels2, ...
    'Inflation Rates (KOREA)', ...
    {'KOR GDPDEF Inflation', 'KOR CPI Inflation'},1)

% f5 = figure('Position',[300 200 1100 600]);
% subplot(4,1,1)
% plot_time_series([kor_gdpdef_inf, kor_cpi_inf], 20, kor_xtick_labels2, ...
%     'KOR GDPDEF Inflation vs CPI Inflation', ...
%     {'KOR GDPDEF Inflation', 'KOR CPI Inflation'},1)
% 
% adj_kor_cpi_inf1 = [kor_cpi_inf(2:end,:);nan(1,1)];
% subplot(4,1,2)
% plot_time_series([kor_gdpdef_inf,adj_kor_cpi_inf1],20, kor_xtick_labels2, ...
%     [], {'KOR GDPDEF Inflation', 'KOR CPI Inflation Lag 1'}, 0)
% 
% subplot(4,1,3)
% adj_kor_cpi_inf2 = [kor_cpi_inf(3:end,:);nan(2,1)];
% plot_time_series([kor_gdpdef_inf,adj_kor_cpi_inf2],20, kor_xtick_labels2, ...
%     [], {'KOR GDPDEF Inflation', 'KOR CPI Inflation Lag 2'}, 0)
% 
% subplot(4,1,4)
% adj_kor_cpi_inf3 = [kor_cpi_inf(4:end,:);nan(3,1)];
% plot_time_series([kor_gdpdef_inf,adj_kor_cpi_inf3],20, kor_xtick_labels2, ...
%     [], {'KOR GDPDEF Inflation', 'KOR CPI Inflation Lag 3'}, 0)

f5 = figure('Position',[300 200 1100 600]);
subplot(2,1,1)
plot(us_pce,'LineWidth',2)
yyaxis left
ylim([0.9*min(us_pce) 1.1*max(us_pce)])

yyaxis right
p1 = plot([us_gdpdef,us_cpi,us_ppi],'LineWidth',2);
set(p1(1), 'LineStyle', '-', 'Color', [0.8500, 0.3250, 0.0980])
set(p1(2), 'LineStyle', '-', 'Color', [0.9290, 0.6940, 0.1250])
set(p1(3), 'LineStyle', '-', 'Color', [0.4940, 0.1840, 0.5560])
axis(get_axis_range([us_gdpdef,us_cpi,us_ppi]))
xticks(1:20:us_T)
xticklabels(us_xtick_labels1)
title('Price Indices (US)', 'FontSize', 20, 'Interpreter', 'latex')
legend({'US PCE', 'US GDPDEF', 'US CPI', 'US PPI'},'Location', 'north', 'Orientation', 'horizontal')
grid on
ax = gca;
ax.YColor = 'k';

subplot(2,1,2)
plot_time_series([us_pce_inf,us_gdpdef_inf,us_cpi_inf,us_ppi_inf], ...
    4:20:dus_T,us_xtick_labels2, ...
    'Inflation Rates (US)', ...
    {'US PCE Inflation', 'US GDPDEF Inflation', 'US CPI Inflation', 'US PPI Inflation'}, 1)

%% 6. Plotting Main Macro Variables for Korea and the US
% (1) Korea
kor_growth = kor_y_inf(:,1);

f6 = figure('Position',[300 200 1100 600]);
subplot(2,2,1)
plot(kor_growth,'LineWidth',2)
yyaxis left
ylim([1.1*min(kor_growth) 1.1*max(kor_growth)])

yyaxis right
plot(kor_unemp,'LineWidth',2, 'LineStyle','-', 'Color', [0.8500, 0.3250, 0.0980])
axis(get_axis_range(kor_unemp))
xticks(1:20:dkor_T)
xticklabels(kor_xtick_labels2)
legend({'Growth','Unemployment'}, 'Location', 'north', 'Orientation', 'horizontal')
ax = gca;
ax.YColor = 'k';
grid on

subplot(2,2,2)
plot_time_series([kor_gdpdef_inf,kor_cpi_inf], ...
    1:20:dkor_T, kor_xtick_labels2, ...
    [], {'GDP Deflator', 'CPI'}, 0)

subplot(2,2,3)
plot_time_series(kor_forex, ...
    1:20:dkor_T, kor_xtick_labels2, ...
    [], {'KRW/USD'}, 0)

subplot(2,2,4)
plot_time_series(kor_int, ...
    1:20:dkor_T, kor_xtick_labels2, ...
    [], {'CALL','CD91', 'Gov1', 'Gov3'}, 0)
sgtitle('Time Series of Macro Variables (KOR)','FontSize',20,'Interpreter','latex')

% (2) US
us_growth = us_y_inf(:,1);

f7 = figure('Position',[300 200 1100 600]);
subplot(2,2,1)
plot(us_growth,'LineWidth',2)
yyaxis left
ylim([1.1*min(us_growth) 1.1*max(us_growth)])

yyaxis right
plot(us_unemp,'LineWidth',2, 'LineStyle','-', 'Color', [0.8500, 0.3250, 0.0980])
axis(get_axis_range(us_unemp))
xticks(4:20:dus_T)
xticklabels(us_xtick_labels2)
legend({'Growth','Unemployment'}, 'Location', 'north', 'Orientation', 'horizontal')
ax = gca;
ax.YColor = 'k';
grid on

subplot(2,2,2)
plot_time_series([us_pce_inf,us_gdpdef_inf,us_cpi_inf,us_ppi_inf], ...
    4:20:dus_T,us_xtick_labels2, ...
    [], {'US PCE Inflation', 'US GDPDEF Inflation', 'US CPI Inflation', 'US PPI Inflation'}, 0)

subplot(2,2,3)
plot_time_series(us_int(:,1:3), ...
    4:20:dus_T, us_xtick_labels2, ...
    [], {'FEDFUNDS','TB3M', 'TB10Y'}, 0)

subplot(2,2,4)
plot_time_series(WTI, ...
    4:20:dus_T, us_xtick_labels2, ...
    [], {'WTI'}, 0)

sgtitle('Time Series of Macro Variables (US)','FontSize',20,'Interpreter','latex')