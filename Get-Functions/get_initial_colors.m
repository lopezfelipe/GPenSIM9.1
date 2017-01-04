function [colors] = get_initial_colors(initial_dynamics)
%        [colors] = get_initial_colors(initial_dynamics)
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
colors = cell(1, Ps);  % initially

icd = initial_dynamics;

if iscell(icd),  % sources = {'p1',{}, 'p2', {}, ...}}
    no_of_sources = length(icd)/2; % number of places  
    % extracting places
    for i = 1:no_of_sources,
        curr_source_name = icd{2*i -1};
        source_nr = check_valid_place(curr_source_name);    
        initial_colors = icd{2*i};          
        colors{source_nr} = initial_colors;       
    end;

else  % sources is a vector: imarkings = [1 3 0 0 1]
    if ne(length(icd), Ps), 
        error('array of initial colors must be same length as number of places');
    end;
    colors = icd;
end;