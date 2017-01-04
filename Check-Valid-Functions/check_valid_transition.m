function [tx] = check_valid_transition(tx)
% function [tx] = check_valid_transition(tx)
% checks whether transition name is valid

%  Reggie.Davidrajuh@uis.no (c) Version 6.0 (c) 10 july 2012  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global PN;

if ischar(tx),   % trans is a character string
    t_index = search_names(tx, PN.global_transitions);
    if (t_index),
        tx = t_index;
    else
        error([tx, ':   Wrong transition name ...']);
    end;    
end;

