function [sfc, new_color, override, new_part_No, selected_tokens, additional_cost, split] = ...
        firing_preconditions_COMMON_PRE(t1)
% function [sfc, new_color, override, selected_tokens] = ...
%        firing_preconditions_COMMON_PRE(t1)    
% 
% This functions checks whether user-defined (if any) 
% conditions are satisfied before firing a transition. 
% The user-defined conditions are defined in TDF 
% 

%  Reggie.Davidrajuh@uis.no (c) Version 6.0 (c) 10 july 2012  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global PN;

transition.name = PN.global_transitions(t1).name;  %name of enabled trans
transition.new_color = {};
transition.override = 0; % by default - inherit
transition.selected_tokens = []; 
transition.additional_cost = 0; % by default: variable cost = 0
transition.new_part_No = {};
transition.split = 0; % by default: do not split

funcname = 'COMMON_PRE';
[sfc, transition] = feval(str2func(funcname), transition);

override = transition.override; 
selected_tokens = transition.selected_tokens;
new_color = transition.new_color;
additional_cost = transition.additional_cost;
new_part_No = transition.new_part_No;
split = transition.split;
if not(iscell(new_color)), 
    new_color = {new_color}; % new colors are to be in cell format
end;
if not(iscell(new_part_No)), 
    new_part_No = {new_part_No}; % new part numbers are to be in cell format
end;
