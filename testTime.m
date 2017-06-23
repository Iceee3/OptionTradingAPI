date = 20170620;
date2 = 20170626;
tic;
for i = 1: 1000
    date3 = datenum(num2str(date),'yyyymmdd');
    date4 = datenum(num2str(date2),'yyyymmdd');
    a = daysact(date3,date4);
end
toc;