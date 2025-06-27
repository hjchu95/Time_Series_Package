%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the code for loading the data from ECOS and FRED and generate an
% excel file.

% 0. Get your open API keys.

% 1. The start and end date for ECOS must maintain the following format.
%   (1) Annual: 2024
%   (2) Quarterly: 2024Q1
%   (3) Monthly: 202401
%   (4) Daily: 20240101

%    For FRED, the start and end date must maintain the following format.
%   (1) 2024-01-01

% 2. Format
%   (1) The format of each variable of ECOS can be seen in the following url.
%       "https://ecos.bok.or.kr/api/#/DevGuide/StatisticalCodeSearch"

%   (2) The format of each variable of FRED can be seen by searching in the 
%       following url.
%       "https://fred.stlouisfed.org/"

% 3. Saving
% The final table will be saved into "tsdata.xlsx" with separate sheet names.

% Written by Hyun Jae Stephen Chu
% 6, August, 2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Settings
clear;clc;
close all

addpath("/Users/hjchu/Library/CloudStorage/Dropbox/Codes/MATLAB/Time_Series")
addpath("/Users/hjchu/Library/CloudStorage/Dropbox/Codes/MATLAB/Time_Series/TS_lib")

%% 1. ECOS
% (1) Local Options
start_date = '2000Q1'; % Start of the date !!! MUST MAINTAIN FORMAT !!!
end_date = '2025Q1'; % End of the date
start_page = '1';
end_page = '10000';
key = 'MQ0GI502T3W668LVZH6C';

options = struct();
options.start_date = start_date;
options.end_date = end_date;
options.start_page = start_page;
options.end_page = end_page;

% (2) Code Dictionary
code_dictionary = [
    struct( ...
        'name', "NGDP_Prod_SA", ...
        'main_code', '200Y103', ...
        'sub_code1', {{'1400', 'NGDPSA'}}, ...
        'sub_code2', '?' ...
    );
    struct( ...
        'name', "RGDP_Prod_SA", ...
        'main_code', '200Y104', ...
        'sub_code1', {{'1400', 'RGDPSA'}}, ...
        'sub_code2', '?' ...
    );
    struct( ...
        'name', "NGDP_Prod_NSA", ...
        'main_code', '200Y105', ...
        'sub_code1', {{'1400', 'NGDPNSA'}}, ...
        'sub_code2', '?' ...
    );
    struct( ...
        'name', "RGDP_Prod_NSA", ...
        'main_code', '200Y106', ...
        'sub_code1', {{'1400', 'RGDPNSA'}}, ...
        'sub_code2', '?' ...
    );
    struct( ...
        'name', "GDP_Deflator", ...
        'main_code', '200Y111', ...
        'sub_code1', {{'1400', 'GDPdef'}}, ...
        'sub_code2', '?' ...
    );
    struct( ...
        'name', "CPI", ...
        'main_code', '901Y009', ...
        'sub_code1', {{'0', 'CPI'}}, ...
        'sub_code2', '?' ...
    )
    struct( ...
        'name', "ExchangeRate", ...
        'main_code', '731Y006', ...
        'sub_code1', {{'0000003', 'Exch'}}, ...
        'sub_code2', '0000100' ...
    )
    struct( ...
        'name', "InterestRates", ...
        'main_code', '721Y001', ...
        'sub_code1', { ...
            {'1020000', 'Call'}; ...
            {'2010000', 'CD91'}; ...
            {'5030000', 'TBill1Y'}; ...
            {'5020000', 'TBill3Y'} ...
        }, ...
        'sub_code2', '?' ...
    )
];

% (3) Building Table
KOR_df = ecos_api(code_dictionary, key, options);

%% 2. FRED
% (1) Local options
fred_key = 'ba6c14c61b7c835966f6bec28069ef42';
start_date = '1960-01-01';
end_date = '2025-03-31';

fred_options = struct();
fred_options.start_date = start_date;
fred_options.end_date = end_date;

% (2) Code Dictionary
code_dictionary = {
    % GDP
    'GDP', 'NGDPSA';
    'NA000334Q', 'NGDPNSA';
    'GDPC1', 'RGDPSA';
    'ND000334Q', 'RGDPNSA';

    % Price
    'GDPDEF', 'GDPDEF';
    'PCEC', 'PCE';
    'CPIAUCSL', 'CPI';
    'PPIACO', 'PPI';

    % Interest Rate
    'FEDFUNDS', 'FFE';
    'GS10', 'T10Y';
    'T10Y3MM', 'T10M3M';

    % Unemployment Rate
    'UNRATE', 'Unemp';

    % Commodity
    'MCOILWTICO', 'WTI';
};

% (3) Building Table
US_df = fred_api(code_dictionary,fred_key,fred_options);

%% 3. US recession data
code_dictionary = {
    % US recession
    'USRECQ', 'USREC';
};

REC_df = fred_api(code_dictionary,fred_key,fred_options);

%% 4. Cleaing US data
% Note that rGDP and PCE are quarterly variables while FFE and T10Y are
% monthly variables.
ind = 1:3:height(US_df);
US_df_final = US_df(ind,"Date");
US_df_final(:,'NGDPSA') = US_df(ind,'NGDPSA');
US_df_final(:,'NGDPNSA') = US_df(ind,'NGDPNSA');
US_df_final(:,'RGDPSA') = US_df(ind,'RGDPSA');
US_df_final(:,'RGDPNSA') = US_df(ind,'RGDPNSA');
US_df_final(:,'GDPDEF') = US_df(ind,'GDPDEF');
US_df_final(:,'PCE') = US_df(ind,'PCE');

K = cols(US_df);

for k = 8:1:K
    qd = zeros(height(US_df_final),1);
    for i = 1:3:height(US_df)
        qd(floor(i/3)+1,1) = (US_df{i,k} + US_df{i+1,k} + US_df{i+2,k})/3;
    end
    name = US_df.Properties.VariableNames(k);
    US_df_final(:,name) = table(qd);
end

%% 5. Saving as xlsx file
writetable(KOR_df,'tsdata_20250627.xlsx','Sheet','KOR','Range','A1:Z300')
writetable(US_df_final,'tsdata_20250627.xlsx','Sheet','US','Range','A1:Z300')
writetable(REC_df,'tsdata_20250627.xlsx','Sheet','REC','Range','A1:B300')
