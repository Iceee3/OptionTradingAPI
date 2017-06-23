function [optionStructArray] = traderGetOptionByDay(beginDate, endDate)
%traderGetOptionByDay Get option contracts of each day during backtest
% Return a struct optionList with 2 fields
%   1. Date: date in MATLAB datenum format
%   2. TargetList: a substruct with available option contracts in that day
% Example:
% optionStructArray = traderGetOptionByDay(20170101, 20170131)
% Note: to use optionStructArray, declare as a global variable
% Jianqiu Wang, jianq.w@bitpower.com.com
% Version 0.0.1 June 16, 2017 First commit
% Version 0.0.2 June 17, 2017 Add comment for function
% Version 0.0.3 June 20, 2017 Modify date into 8-digit double type
% Version 0.0.4 June 22, 2017 Save data as local file

    % Creat a struct array from beginDate to endDate with field Date
    dates = datenum([num2str(beginDate);num2str(endDate)],'yyyymmdd');
    [beginDateInDN,endDateInDN] = deal(dates(1),dates(2)); % DN is short for datenum
    numDaysBetween = daysact(beginDateInDN,endDateInDN)+1;

    % Construct a date matrix with each row as a date
    yearVector = repmat(year(beginDateInDN),numDaysBetween,1);
    monthVector = repmat(month(beginDateInDN),numDaysBetween,1);
    dayVector = day(beginDateInDN)-1+[1:numDaysBetween]';
    dateMat = datenum([yearVector monthVector dayVector]);

    % Transform into 8-digit number as feild Date
    dateInDouble = string2Double(dateMat);
    dateInCell = num2cell(dateInDouble);
    optionStructArray(length(dateInDouble)).Date = 0; % Initialize struct array
    [optionStructArray.Date] = dateInCell{:};

    allOption = traderGetOptionCodeList('sse','510050',beginDate,endDate);

    for i = 1:length(allOption)
        optionInfo = traderGetOptionInfo(allOption(i).Market,allOption(i).Code);
        optionStructArray(i).TargetList = [];
        % Faster to transform into double type first
        startDate = string2Double(datenum(optionInfo.StartDate,'yyyy-mm-dd'));
        endDate = string2Double(datenum(optionInfo.EndDate,'yyyy-mm-dd'));
        for j = 1:length(optionStructArray)
            % Pick option valid in that day
            if (optionStructArray(j).Date >= startDate) && ...
               (optionStructArray(j).Date <= endDate)
               nextTarget = length(optionStructArray(j).TargetList)+1;
               optionStructArray(j).TargetList(nextTarget).Code = allOption(i).Code;
           end
        end
    end
end
