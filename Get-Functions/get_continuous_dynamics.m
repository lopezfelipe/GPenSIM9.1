function [xdot] = get_continuous_dynamics(initial_dynamics)
%        [xdot] = get_continuous_dynamics(initial_dynamics)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function extracts a group of elements from a given inputs of
% global_elements and elements. The resulting output is an element matrix.
% function elements_m = elements_matrix(pn.global_elements, elements)
% Inputs:
%       -global elements
%      - elements
% Output: elemets matrix

% lopezfe@umich Dec 26 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global PN;

Ps = PN.No_of_places;
xdot = cell(1, Ps);  % initially

icd = initial_dynamics;

if iscell(icd),  % sources = {'p1','xdot1', 'p2', 'xdot2', ...}}
    no_of_sources = length(icd)/2; % number of places  
    % extracting places
    for i = 1:no_of_sources,
        curr_source_name = icd{2*i -1};
        source_nr = check_valid_place(curr_source_name);    
        continuous_dynamics = icd{2*i};          
        xdot{source_nr} = continuous_dynamics;       
    end;

else  % sources is a vector: imarkings = [1 3 0 0 1]
    if ne(length(icd), Ps), 
        error('array of continuous dynamics must be same length as number of places');
    end;
    xdot = icd;
end;