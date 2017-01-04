function [sfc, new_color,override,new_part_No,selected_tokens, additional_cost, split] = ...
        firing_preconditions(t1)
% [sfc] = firing_preconditions(transition1)
% (any pre-conditions for firing?) 
% 
% This functions checks whether user-defined (if any) 
% conditions are satisfied before firing a transition. 
% The user-defined conditions are defined in TDF 
% 
% Define variables: 
% Inputs:  transition1 : index of the transition inside PN
%
% Output: Boolean value (true/false), based on whether 
% 		user-defined conditions are met or not.
%
% Functions called: 
%         	(feval) 
% 

%  Reggie.Davidrajuh@uis.no (c) Version 6.0 (c) 10 july 2012  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global PN;

new_color = {};
override = 0; % by default, do not override earlier colors
selected_tokens = [];
additional_cost = 0;
new_part_No = {};
split = 0;

% first, check specific_pre conditions, if exist
if PN.PRE_exist(t1),
    [sfc, new_color1, override1, new_part_No1, selected_tokens1, additional_cost1, split1] = ...
        firing_preconditions_specific_pre(t1);
    new_color = new_color1;
    override = override1; 
    selected_tokens = selected_tokens1;
    additional_cost = additional_cost1;
    new_part_No = new_part_No1;
    split = split1;
else
    sfc = 1;  % in case no specifc_pre file exist
end;

% if conditions in the specific_pre are NOT satisfied, 
%      then no point in to continue with COMMON_PRE
% !!!!! Wrong: COMMON_PRE can do some common actions
% if not(sfc), return; end;
    
% second, check COMMON_PRE conditions, if exist

if PN.COMMON_PRE,
    [sfc2, new_color2, override2, new_part_No2, selected_tokens2, additional_cost2, split2] = ...
        firing_preconditions_COMMON_PRE(t1);
    
    %new_color = union(new_color, new_color2);
    override = or(override, override2); 
    selected_tokens = [selected_tokens selected_tokens2];
%     %%%%%%%%%  purge slected tokens (get rid of 0s)
%     selected_tokens = selected_tokens(any(selected_tokens));
    additional_cost = additional_cost + additional_cost2;
    new_part_No = new_part_No2;
    split = or(split,split2);
    if ~split2,
        new_color = union(new_color, new_color2);
        new_part_No = union(new_part_No, new_part_No2);
    else
        new_color = get_colors_split(new_color2);
        new_part_No = get_colors_split(new_part_No2);
    end;
else
    sfc2 = 1;    % if no TDF, then always fire if enabled. 
end;

sfc = and(sfc, sfc2); % satisfied firing conditions 
