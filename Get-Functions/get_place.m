function px = get_place(place_name)
% [px] = get_place('place_name')
%
% E.g. p1 = place('buffer_1');
%
% This function extracts place from Petri net structure.
%
% Define variables: 
% Inputs: 	
%          place_name: a name (string) identifying the place
%
% Output:  place 
% 
% Functions called : (none)

% RD 05.may.2006
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global PN;

global_places = PN.global_places;
p_index = search_names(place_name, global_places);
if (p_index),
    px = global_places(p_index);
else
    px = [];
end;

