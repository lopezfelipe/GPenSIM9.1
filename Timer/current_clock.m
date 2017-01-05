function [current_clock_HMS] = current_clock(secs_or_HHMMSS)
% function [current_clock_HMS] = current_clock(secs_or_HHMMSS)
%       secs_or_HHMMSS = 1 : returns seconds
%       secs_or_HHMMSS = 3 : returns [hour min sec]
%
%       Reggie Davidrajuh (c) August 2011

current_clock = clock; % time in [YY MM DD hh mm ss] 
fixed_clock = fix(current_clock);
ms = fix( 1000*(current_clock(6)-fixed_clock(6)) );
sec = fixed_clock(6);
min = fixed_clock(5);
hour = fixed_clock(4);

if eq(secs_or_HHMMSS, 1),
    % convert to seconds
    current_clock_HMS = sec + ms/1000 + (60 * min) + (60 * 60 * hour); 
elseif eq(secs_or_HHMMSS, 3),
    % convert to [hour min sec ms]
    current_clock_HMS = [hour min sec ms]; 
else
    error('input argument must be either 1 or 3');
end;
