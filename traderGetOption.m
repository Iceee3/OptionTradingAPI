function [selectedTargetList] = traderGetOption(currentDate, monthLevel, priceLevel, optionType, optionStructArray)
%traderGetOptionParity Get option contract of currentDate
    switch nargin
        case 0
            error('Insufficient number input for traderGetOptionParity function!');
        case 1
            if mod(currentDate, 1) ~=0
                error('Only date part of datenum format will be accepted, using datenum format and take floor of it!')
            end
            monthLevel = 0;
            priceLevel = 0;
            optionType = 'all';
        case 2
            priceLevel = 0;
            optionType = 'all';
        case 3
            optionType = 'all';
    end


    if isempty(optionStructArray)
        beginDate = str2double(datestr(currentDate,'yyyymmdd'));
        endDate = beginDate;
        targetList = traderGetOptionCodeList('sse','510050',beginDate,endDate);
    else
        % Search for targetList on the date
        optionStructArray
        day1 = datenum(num2str(optionStructArray(1).Date),'yyyymmdd');
        numDay = daysact(day1, currentDate) + 1
        targetList = optionStructArray(numDay).TargetList;
    end

    if isempty(targetList)
        error('Empty targetList! Check data!');
    end

    % Read option info
    for i = 1:length(targetList)
        optionInfo = traderGetOptionInfo('sse',targetList(i).Code);
        targetList(i).CallOrPut = optionInfo.CallOrPut;
        targetList(i).ExercisePrice = optionInfo.ExercisePrice;
        targetList(i).ExerciseDate = datestr(datenum(optionInfo.ExerciseDate),'yyyy/mm'); % Exercise month
    end

    currentDateInNum = str2double(datestr(currentDate,'yyyymmdd'));
    [~,udlyPrice,~,~,~,~,~,~] = traderGetKData('SSE','510050','day',1,currentDateInNum,currentDateInNum,false,'FWard');

    targetList1 = traderSelectOptionByType(targetList,'c');
    targetList1 = traderSelectOptionByExpireMonth(targetList1,monthLevel);
    targetList1 = traderSelectOptionByPriceLevel(targetList1,udlyPrice,priceLevel);

    targetList2 = traderSelectOptionByType(targetList,'p');
    targetList2 = traderSelectOptionByExpireMonth(targetList2,monthLevel);
    targetList2 = traderSelectOptionByPriceLevel(targetList2,udlyPrice,priceLevel);

    if strcmp(optionType,'c')
        selectedTargetList = targetList1;
    elseif strcmp(optionType,'p')
        selectedTargetList = targetList2;
    else
        if length(targetList1) ~= 1 && length(targetList2) ~= 1
            error('Some wired error! Check call and put separatedly!')
        else
          selectedTargetList(1) = targetList1;
          selectedTargetList(2) = targetList2;
        end
    end
  end
