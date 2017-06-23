function dateInDouble = string2Double(date)
% date is a string with form 'yyyy-mm-dd'
% Transform into a double type: yyyymmdd in MATLAB 2013a environment
% Jianqiu Wang, jw2329@cornell.edu
% Version 0.0.1 June 15, 2017  First commit
    dateInNum = datenum(date);
    dateInDouble = 10000*year(dateInNum)...
                 + 100*month(dateInNum)...
                 + day(dateInNum);
end
