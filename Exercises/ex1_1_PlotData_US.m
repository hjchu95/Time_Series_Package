%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This exercise plots the macro data of the US.

% The "tsdata_date.xlsx" file obtained from ex0_openAPI.m is necessary to
% run the code below.

% Written by Hyun Jae Stephen Chu
% July 8th, 2025
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 0. Settings
clear;clc;
close all
rng(123)

addpath("/Users/hjchu/Documents/GitHub/Time_Series_Package/Exercises")
addpath(genpath("/Users/hjchu/Documents/GitHub/Time_Series_Package/TS_lib"))

us_xtick_labels1 = {'1960','1965','1970','1975','1980','1985','1990','1995','2000','2005','2010','2015','2020','2025'};
us_xtick_labels2 = {'1961','1966','1971','1976','1981','1986','1991','1996','2001','2006','2011','2016','2021'};

save_folder = 'ex1_1_results';

fig_option = struct( ...
    'legori','h', ...
    'legx', 0.36, ...
    'legy', 0.84, ...
    'width', 700, ...
    'height', 450, ...
    'margin', struct('t', 10, 'l', 5, 'r', 5, 'b', 0) ...
    );
fig_option_onevar = struct( ...
    'legori','h', ...
    'legloc','north', ...
    'legx', 0.395, ...
    'legy', 0.84, ...
    'width', 700, ...
    'height', 450, ...
    'margin', struct('t', 10, 'l', 5, 'r', 5, 'b', 0) ...
    );
fig_option_fourvar = struct( ...
    'legori','h', ...
    'legloc','north', ...
    'legx', 0.25, ...
    'legy', 0.82, ...
    'width', 700, ...
    'height', 450, ...
    'margin', struct('t', 10, 'l', 5, 'r', 5, 'b', 0) ...
    );
fig_option_two = struct( ...
    'width', 700, ...
    'height', 700, ...
    'margin', struct('t', 30, 'l', 5, 'r', 5, 'b', 10) ...
    );

%% 1. Loading Data
US_data = readmatrix("tsdata_20250704.xlsx",'Sheet','US','Range','B2:O262');
% 1960 Q1 ~ 2025 Q1
% NGDPSA, NGDPNSA, RGDPSA, RGDPNSA, GDPDEF, PCE, CPI, PPI, FFE, T10Y,
% T10M3Y, UNEMP, WTI

%% 2. Comparing Seasonally Adjusted Data
us_NGDPSA = US_data(:,1)./4; % Seasonally Adjusted Annualized Rate to Quarterly
us_NGDPNSA = US_data(:,2)*0.001; % millions of dollars to billions of dollars
us_RGDPSA = US_data(:,3)./4; % Seasonally Adjusted Annualized Rate to Quarterly
us_RGDPNSA = US_data(:,4);

us_T = rows(us_NGDPNSA);

f1 = figure('Position',[300 200 1100 600]);
plot_time_series([us_NGDPNSA, us_NGDPSA], ...
    1:20:us_T,us_xtick_labels1, ...
    'US NGDP Seasonally Adjusted vs Not Seasonally Adjusted', ...
    {'US NGDPNSA','US NGDPSA'},0)
save_as_html(f1,save_folder,'figure1',fig_option)

us_NGDPNSA_qoq = ts_diff(us_NGDPNSA,'qoq_diff');
dus_T = rows(us_NGDPNSA_qoq);
f2 = figure('Position',[300 200 1100 600]);
plot_time_series(us_NGDPNSA_qoq, ...
    4:20:dus_T,us_xtick_labels2, ...
    'US NGDP NSA Quarter-on-Quarter Difference (QoQ)', ...
    {'US NGDPNSA QoQ Difference'}, 0)
save_as_html(f2,save_folder,'figure2',fig_option_onevar)

us_NGDPNSA_qoqdiff = ts_diff(us_NGDPNSA,'qoq_gr');
dus_T = rows(us_NGDPNSA_qoq);
f3 = figure('Position',[300 200 1100 600]);
plot_time_series(us_NGDPNSA_qoqdiff, ...
    4:20:dus_T,us_xtick_labels2, ...
    'US NGDP NSA Quarterly Growth Rate', ...
    {'US NGDPNSA QoQ Growth Rate'}, 0)
save_as_html(f3,save_folder,'figure3',fig_option_onevar)

us_NGDPNSA_yoydiff = ts_diff(us_NGDPNSA,'yoy_diff');
dus_T = rows(us_NGDPNSA_yoydiff);
f4 = figure('Position',[300 200 1100 600]);
plot_time_series(us_NGDPNSA_yoydiff, ...
    1:20:dus_T,us_xtick_labels2, ...
    'US NGDP NSA Year-on-Year Difference (YoY)', ...
    {'US NGDPNSA YoY Difference'}, 0)
save_as_html(f4,save_folder,'figure4',fig_option_onevar)

us_NGDPNSA_yoy = ts_diff(us_NGDPNSA,'yoy_gr');
dus_T = rows(us_NGDPNSA_yoy);
f5 = figure('Position',[300 200 1100 600]);
plot_time_series(us_NGDPNSA_yoy, ...
    1:20:dus_T,us_xtick_labels2, ...
    'US NGDP NSA Annual Growth Rate', ...
    {'US NGDPNSA YoY Growth Rate'}, 0)
save_as_html(f5,save_folder,'figure5',fig_option_onevar)

%% 3. Converting Variables
us_change = [US_data(:,5:8)];
us_int = US_data(2:end,9:12);
us_unemp = US_data(2:end,13);
WTI = US_data(2:end,14);

us_y_inf = ts_diff(us_change,'qoq_gr');

us_gdpdef = US_data(:,5);
us_pce = US_data(:,6);
us_cpi = US_data(:,7);
us_ppi = US_data(:,8);
us_gdpdef_inf = us_y_inf(:,1);
us_pce_inf = us_y_inf(:,2);
us_cpi_inf = us_y_inf(:,3);
us_ppi_inf = us_y_inf(:,4);

dus_T = rows(us_gdpdef_inf);

%% 4. Comparing Nominal and Real GDP
f6 = figure('Position',[300 200 1100 600]);
plot_time_series([log(us_NGDPSA), log(us_RGDPSA)], ...
    1:20:us_T,us_xtick_labels1, ...
    'US NGDPSA vs RGDPSA', ...
    {'log US NGDPSA', 'log US RGDPSA'}, 0)
save_as_html(f6,save_folder,'figure6',fig_option)

% Comparing Annual Growth Rates
% us_ngdp_growth = ts_diff(US_data(:,1),'qoq_gr');
us_ngdp_growth = ts_diff(us_NGDPSA,'qoq_gr');
us_growth = ts_diff(us_RGDPSA,'qoq_gr');
us_rgdp_growth = us_growth;
us_gdpdef_growth = us_gdpdef_inf;

us_ngdp_qg = meanc(us_ngdp_growth);
us_ngdp_ag = 4*us_ngdp_qg;

us_rgdp_qg = meanc(us_rgdp_growth);
us_rgdp_ag = 4*us_rgdp_qg;

us_gdpdef_qg = meanc(us_gdpdef_growth);
us_gdpdef_ag = 4*us_gdpdef_qg;

data = [us_ngdp_qg,us_ngdp_ag;us_rgdp_qg,us_rgdp_ag;us_gdpdef_qg,us_gdpdef_ag];

rowNames = {'NGDP'; 'RGDP'; 'GDPDEF'};
colNames = {'  Quarterly','  Annual'};

fprintf('Full-sample: 1960 Q2 - 2025 Q1\n')
fprintf('%-10s %10s %10s\n', 'Variable', colNames{:});
fprintf('%s\n', repmat('-', 1, 32));
for i = 1:length(rowNames)
    fprintf('%-10s   %10.2f   %10.2f\n', rowNames{i}, data(i,1), data(i,2));
end

f7a = figure('Position',[300 200 1100 600]);
plot_time_series(us_gdpdef, ...
    1:20:us_T,us_xtick_labels1, ...
    '', ...
    {'US GDP Deflator'}, 0)
save_as_html(f7a,save_folder,'figure7a',fig_option_onevar)

f7b = figure('Position',[300 200 1100 600]);
plot_time_series(us_gdpdef_inf, ...
    1:20:dus_T,us_xtick_labels2, ...
    '', ...
    {'US Inflation (GDP Deflator)'}, 0)
save_as_html(f7b,save_folder,'figure7b',fig_option_onevar)

%% 5. Comparing Price Index and Inflation Rate
f8a = figure('Position',[300 200 1100 600]);
plot_time_series([log(us_gdpdef),log(us_cpi)], 1:20:us_T, us_xtick_labels1, ...
    'Price Indices (US)', {'log(US GDPDEF)','log(US CPI)'},0)
save_as_html(f8a,save_folder,'figure8a',fig_option)

f8b = figure('Position',[300 200 1100 600]);
plot_time_series([us_gdpdef_inf,us_cpi_inf], 1:20:dus_T, us_xtick_labels2, ...
    'Price Indices (US)', {'US GDPDEF','US CPI'},0)
save_as_html(f8b,save_folder,'figure8b',fig_option)

us_gdpdef_inf_qg = meanc(us_gdpdef_inf);
us_gdpdef_inf_ag = 4*us_gdpdef_inf_qg;
us_gdpdef_inf_std = std(us_gdpdef_inf);

us_cpi_inf_qg = meanc(us_cpi_inf);
us_cpi_inf_ag = 4*us_cpi_inf_qg;
us_cpi_inf_std = std(us_cpi_inf);

data1 = [us_gdpdef_inf_qg,us_gdpdef_inf_ag,us_gdpdef_inf_std;
    us_cpi_inf_qg,us_cpi_inf_ag,us_cpi_inf_std];

rowNames = {'GDPDEF'; 'CPI'};
colNames = {'  Quarterly','  Annual', 'Std'};

fprintf('\nFull-sample: 1960 Q2 - 2025 Q1\n')
fprintf('%-10s %10s %10s %10s\n', 'Variable', colNames{:});
fprintf('%s\n', repmat('-', 1, 32));
for i = 1:length(rowNames)
    fprintf('%-10s   %10.2f   %10.2f   %10.2f\n', rowNames{i}, data1(i,1), data1(i,2), data1(i,3));
end

%% 6. Plotting Labor Market Indicators

%% 7. Plotting Main Macro Variables for the US
f13a = figure('Position',[300 200 1100 600]);
plot_yyaxis(us_growth,us_unemp,4:20:dus_T,us_xtick_labels2, ...
    [],{'Growth','Unemployment'},0)
save_as_html(f13a,save_folder,'figure13a',fig_option)

f13b = figure('Position',[300 200 1100 600]);
plot_time_series([us_pce_inf,us_gdpdef_inf,us_cpi_inf,us_ppi_inf], ...
    4:20:dus_T,us_xtick_labels2, ...
    [], {'US PCE', 'US GDPDEF', 'US CPI', 'US PPI'}, 0)
save_as_html(f13b,save_folder,'figure13b',fig_option_fourvar)

f13c = figure('Position',[300 200 1100 600]);
plot_time_series(us_int(:,1:3), ...
    4:20:dus_T, us_xtick_labels2, ...
    [], {'FEDFUNDS','TB3M', 'TB10Y'}, 0)
save_as_html(f13c,save_folder,'figure13c',fig_option)

f13d = figure('Position',[300 200 1100 600]);
plot_time_series(WTI, ...
    4:20:dus_T, us_xtick_labels2, ...
    [], {'WTI'}, 0)
save_as_html(f13d,save_folder,'figure13d',fig_option)
