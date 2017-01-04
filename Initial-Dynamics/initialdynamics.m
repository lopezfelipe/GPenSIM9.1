function [PNI] = initialdynamics(png, dynamicpart)
%        [PNI] = initialdynamics(png, dynamicpart)
% 
% Name:	initialdynamics
% Purpose:	To create a Petri Net structure with initial dynamics
%           so that it ready for simulation
%
% Input parameters:	Static Petri net structure (output from ‘petrinetgraph’)
%                   initial dynamics
%
% Out parameters:	Petri Net structure with initial dynamics
% Uses:	gpensim_ver, initial_markings, init_token_bank, 
%       firing_times, state_space,  
%       timed_gpensim
% Used by:	[main simulation file]
% Example:	
%   % in main simulation file
%   [pni] = initialdynamics(png, dyn);
%   sim_results = gpensim(pni);
% 

%  Reggie.Davidrajuh@uis.no (c) Version 8.0 (c) 10 June 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global global_info;
if isempty (global_info),
    global_info.DUMMY = 'DUMMY';
end;

global PN;
PN = png;    % PN is global PetriNet model that will be bulid here

if eq(nargin,1), % no initial dynamics given 
    warning('initialdynamics expects 2 parameters: pns & initial dyn'); 
    disp(' ');
    dynamicpart = [];
end;

% handle OPTIONS
set_options();    

% handle dynamic informations  such as "initial markings (m0)", 
%   "firing times (ft)", "initial priority (ip)", "resources", and
%   "continuous dynamics (cd)"
set_initial_dynamics(dynamicpart);

% check whether Preconditions and Postactions are available:
%      files: tdf_pre, tdf_post, COMMON_PRE, and COMMON_POST
set_pre_post_files_register();  % if exist, set the flag for TDF  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% finally, return the PN structure with initial dynamics
PNI = PN;
