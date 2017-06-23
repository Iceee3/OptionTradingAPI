function [selectedTargetList] = traderSelectOptionByType(targetList,optionType)
% traderSelectOptionByType: Select option targetList with different
% expiration month
% Return a modified targetList
% Input:
%   1. original targetList: a struct with field CallOrPut,
%   2. optionType: char type, 'c' for call, 'p' for put, 'all' for both
% Example
% selectTargetList =  traderSelectOptionByType(targetList,'all');
% selectTargetList =  traderSelectOptionByType(targetList,'c');
% selectTargetList =  traderSelectOptionByType(targetList);
% Jianqiu Wang, jianq.w@bitpower.com
% Version 0.1, June 18, 2017: First commit

    switch nargin
        case 0
            error('Insufficient number input for traderGetOptionByType function!');
        case 1
            optionType = 'all';
        case 2
            optionType = upper(optionType);
            if ~ismember(optionType,{'C','P','ALL'})
                error('Wrong type of option type, please input string c, p or all');
            end
        otherwise
            error('More input parameters than expected!')
    end

    if ~ismember('CallOrPut',fieldnames(targetList))
        error('Check field CallOrPut of struct!');
    end

    if strcmp(optionType,'ALL')
        selectedTargetList = targetList;
    else
        allOptionType = {'C','P'};
        selected = ismember({targetList(:).CallOrPut},allOptionType(ismember(allOptionType,optionType)));
        selectedTargetList = targetList(selected);
    end
end
