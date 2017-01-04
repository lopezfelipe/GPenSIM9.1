function [] = set_initial_colors(initial_colors)
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

initial_colors = get_initial_colors(initial_colors);

for i = 1:Ps
    
    if ( PN.global_places(i).tokens >= length(initial_colors{i}) ),
        for j = 1:length(initial_colors{i})
            PN.global_places(i).token_bank(j).color = initial_colors{i}(j);
        end;
    else
        error('Trying to assign too many colors to initial tokens');
    end;
    
end