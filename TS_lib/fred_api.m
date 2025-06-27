function US_df = fred_api(code_dictionary,key,options)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Downloading economic data of the United States using FRED Open API

% Args:
%   code_dictionary: Dictionary containing statistical codes for specific
%   variable
%   key: API key (registered from "https://fred.stlouisfed.org/docs/api/api_key.html")
%   options: start date, end date options

% Returns:
%   US_df: Table of variables

% Written by Hyun Jae Stephen Chu
% June 26th, 2025
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
US_df = table(); % empty table
start_date = options.start_date;
end_date = options.end_date;

for i = 1:size(code_dictionary,1)
    main_code = code_dictionary{i, 1};
    label = code_dictionary{i, 2};
    disp("Current Variable: " + label)

    url = ['https://api.stlouisfed.org/fred/series/observations?series_id=', main_code, ...
           '&api_key=', key,...
           '&observation_start=', start_date, '&observation_end=', end_date];

    xmlData = webread(url);
    % Save the xml content to a temporary file
    tempFilename = [tempname, '.xml'];
    fid = fopen(tempFilename, 'wt');
    fprintf(fid, '%s', xmlData);
    fclose(fid);

    % Read the xml content from the file
    xmlStruct = readstruct(tempFilename);
    delete(tempFilename);

    TIME_list = [];
    DATA_VALUE_list = [];

    rows = xmlStruct.observation;

    for k = 1:length(rows)
        DATA_VALUE = rows(k).valueAttribute;
        TIME = string(rows(k).dateAttribute,'yyyyMMdd');

        TIME_list = [TIME_list,TIME];
        DATA_VALUE_list = [DATA_VALUE_list, DATA_VALUE];
    end

    temp = table(TIME_list', DATA_VALUE_list', 'VariableNames', {'Date', label});
    if i == 1
        US_df = temp;
    else
        US_df = outerjoin(US_df, temp, 'MergeKeys', true, 'Keys', 'Date');
    end
end


end