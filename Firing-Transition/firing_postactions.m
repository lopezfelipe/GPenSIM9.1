function [] = firing_postactions(fired_transition)
% [global_info] = firing_postactions(PN, fired_transition, global_info)
% (any post-actions after firing?) 
% 
% This functions checks whether user-defined (if any) 
% conditions are satisfied before firing a transition. 
% The user-defined conditions are defined in TDF 
% 
% Define variables: 
% Inputs:  transition1 : index of the transition inside PN
%		PN : the strcture for the Petri net
%
% Output: Boolean value (true/false), based on whether 
% 		user-defined conditions are met or not.
%
% Functions called: 
%         	(feval) 

%  Reggie.Davidrajuh@uis.no (c) Version 6.0 (c) 10 july 2012  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global PN;

% get the name of the fired transition
name = PN.global_transitions(fired_transition).name;
transition.name = name; %new structure as input parameter for _POST files

% First, if specific TDF file for post actions exist, then run it
if PN.POST_exist(fired_transition),
    funcname = [name '_post'];
    feval(str2func(funcname), transition);
end;

% second, if COMMON POST actions exist, then run it
if PN.COMMON_POST,
    funcname = 'COMMON_POST';
    feval(str2func(funcname), transition);
end;

