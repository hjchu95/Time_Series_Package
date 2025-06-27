function KOR_df = ecos_api(code_dictionary, key, options)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Downloading economic data of South Korea using ECOS Open API

% Args:
%   code_dictionary: Dictionary containing statistical codes for specific
%   variable
%   key: API key (registered from "https://ecos.bok.or.kr/api/#/")
%   options: start date, end date, start page, end page options

% Returns:
%   KOR_df: Table of variables

% Written by Hyun Jae Stephen Chu
% June 26th, 2025
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
KOR_df = table(); % empty table

start_date = options.start_date;
end_date = options.end_date;
start_page = options.start_page;
end_page = options.end_page;

for i = 1:length(code_dictionary)
    info = code_dictionary(i);
    main_code = info.main_code;
    sub_code1_list = info.sub_code1;
    sub_code2 = info.sub_code2;

    for j = 1:size(sub_code1_list, 1)
        code1 = sub_code1_list{j, 1};
        label = sub_code1_list{j, 2};
        disp("Current Variable: " + label)
        url = ['https://ecos.bok.or.kr/api/StatisticSearch/', key, '/xml/kr/', ...
               start_page, '/', end_page, '/', main_code, '/Q/', start_date, ...
               '/', end_date, '/', code1, '/', sub_code2, '/?'];

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
        ITEM_NAME1_list = [];

        rows = xmlStruct.row;
        for k = 1:length(rows)
            ITEM_NAME1 = rows(k).ITEM_NAME1;
            DATA_VALUE = rows(k).DATA_VALUE;
            TIME = rows(k).TIME;

            TIME_list = [TIME_list,TIME];
            DATA_VALUE_list = [DATA_VALUE_list, DATA_VALUE];
            ITEM_NAME1_list = [ITEM_NAME1_list, ITEM_NAME1];
        end

        temp = table(TIME_list', DATA_VALUE_list', 'VariableNames', {'Date', label});
        if i == 1
            KOR_df = temp;
        else
            KOR_df = outerjoin(KOR_df, temp, 'MergeKeys', true, 'Keys', 'Date');
        end
    end
end

end