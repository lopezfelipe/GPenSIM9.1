function [px] = check_valid_place(px)
% function [px] = check_valid_place(px)
% checks whether place name is valid

%  Reggie.Davidrajuh@uis.no (c) Version 6.0 (c) 10 july 2012  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global PN;

if ischar(px),   % place is a character string
    p_index = search_names(px, PN.global_places);
    if (p_index),
        px = p_index;
    else
        error([px, ':   Wrong place name in "select_token_color"']);
    end;    
end;

