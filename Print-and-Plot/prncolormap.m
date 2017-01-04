function [] = prncolormap(Sim_Results, place)
% [] = print_colormap(pn, Sim_Results, place)
% 
% Name:	print_colormap
% Purpose:	To print colors of the tokens
% Input parameters:	Simulation Results (the structure output by ‘gpensim’)
%                   {set_of_place_names}
% Out parameters:	None
% Uses:	print_colormap_for_place 
% Used by:	[main simulation file]
% Example:	
%   % in main simulation file
%   results = gpensim(pn, dynamicpart);
%   print_colormap(results, {'pNUM1','pADDED', 'pRESULT'}); 
% 

disp('');
disp('Printing Colormap ...');

% no specific place(s) are given; print all colors for all places
if eq(nargin, 1),   % 
    for i = 1: Sim_Results.No_of_places, % all the places
        print_colormap_for_place(Sim_Results, ...
            Sim_Results.global_places(i).name);
    end;
    return
end;
    

if eq(nargin, 2),   % specific place(s) is given
    if ischar(place), % only a specific place is given
        print_colormap_for_place (Sim_Results, place);
    else
        for i=1:length(place), % set of places are given
            print_colormap_for_place (Sim_Results, place{i});
        end;
    end;
    return;
end;
