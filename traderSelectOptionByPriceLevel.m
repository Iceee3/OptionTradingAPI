function [selectedOption] = traderSelectOptionByPriceLevel(targetList,udlyPrice,priceLevel)
% traderSelectOptionByExpireMonth: Select option targetList with different
% expiration month
% Return a modified targetList
% Input:
%   1. original targetList: a struct with field ExerciseDate, 'mm/yyyy'\
%   2.
% Example
% selectTargetList =  traderSelectOptionByExpireMonth(targetList,1);
% Jianqiu Wang, jianq.w@bitpower.com
% Version 0.1, June 18, 2017: First commit
    switch nargin
        case 0
            error('Check function input!')
        case 1
            error('Check function input: undlyPrice')
        case 2
            priceLevel = 0;
        case 3
            if priceLevel~=0 && mod(priceLevel,1)
                error('priceLevel should be a integer!');
            end
        otherwise
            error('More parameters input than expected!')
    end

    if ~ismember('ExercisePrice',fieldnames(targetList))
        error('Check field ExercisePrice of struct array!');
    end

    [~,index] = sort([targetList.ExercisePrice],'descend');
    sortedTargetList = targetList(index);

    % Find minimum price difference
    minPriceDiff = min(abs([targetList.ExercisePrice]-udlyPrice(end)*ones(1,length(targetList))))
    % 
    targetIndex = find(abs([sortedTargetList(:).ExercisePrice]-udlyPrice(end)) == minPriceDiff);
    if or(max(targetIndex) + priceLevel > length(targetList), min(targetIndex) + priceLevel <= 0)
        disp('No option with such level exists');
        selectedOption = struct('TargetList', 0);
    elseif priceLevel == 0
        selectedOption = sortedTargetList(targetIndex);
    else
        selectedOption = sortedTargetList(targetIndex + priceLevel);
    end
end
