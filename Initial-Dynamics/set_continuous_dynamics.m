function [] = set_continuous_dynamics(continuous_dynamics)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function defines continuous dynamics as attributes of places, to
% support hybrid simulation with GPenSIM.
% Inputs:
%       - names of set of ODEs
% Outputs:

% lopezfe@umich.edu - Beta version Dec 23 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global PN;
Ps = PN.No_of_places;

xdot = get_continuous_dynamics(continuous_dynamics);

for i = 1:Ps
    
    if ( strcmp(xdot{i}, '') || isempty(xdot{i}) ),
        PN.global_places(i).contdyn = {};
    elseif ( exist(xdot{i}) == 2 )
        PN.global_places(i).contdyn = xdot{i};
        PN.global_Vplaces(i).contdyn = xdot{i};
    else
        error('Differential equation not defined');
    end
    
end