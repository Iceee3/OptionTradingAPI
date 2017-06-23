function [selectedTargetList] = traderSelectOptionByExpireMonth(targetList,monthLevel)
% traderSelectOptionByExpireMonth: Select option targetList with different
% expiration month
% Return a modified targetList
% Input:
%   1. original targetList: a struct with field ExerciseDate, 'mm/yyyy'\
%   2. monthLevel: , 0 for the next expiration in targetlist, 1 for next,
%      and so on.
% Example
% selectTargetList =  traderSelectOptionByExpireMonth(targetList,1);
% Jianqiu Wang, jianq.w@bitpower.com
% Version 0.1, June 18, 2017: First commit
    switch nargin
        case 0
            error('Check function input of traderSelectOptionByType')
        case 1
            monthLevel = 0;
        case 2
            if monthLevel ~= 0 && mod(monthLevel,1)
                error('MonthLevel should be a number!');
            elseif monthLevel < 0
                error('MonthLevel should be equal to or greater than 0!')
            end
        otherwise
            error('More input parameters than expected!')
    end

    if ~ismember('ExerciseDate',fieldnames(targetList))
        error('Check field ExerciseDate of struct!');
    end

    allMonth = unique({targetList(:).ExerciseDate});

    if monthLevel > length(allMonth) - 1
        error('No available option with specific monthLevel exists!')
    end

    [~,index] = sort(datenum(allMonth,'mm/yyyy'));
    allMonth = allMonth(index);
    targetMonth = allMonth(monthLevel+1);
    selected = ismember({targetList(:).ExerciseDate},targetMonth);
    selectedTargetList = targetList(selected);
end
