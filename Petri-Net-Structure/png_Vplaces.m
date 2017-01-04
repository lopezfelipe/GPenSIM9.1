function [PN] = png_Vplaces(PN)
%        [PN] = png_Vplaces(PN)
%

%  New in v.7
%  Reggie.Davidrajuh@uis.no (c) Version 7.0 (c) 10 july 2012  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% treating set_of_places
Ps = PN.No_of_places; 

% allocate empty matrix for accomodating Virtual places 
global_Vplaces = []; 

% extracting elements
for i = 1:Ps,
    Vplace.name = ['V' PN.global_places(i).name]; % name of the place
    Vplace.tokens = 0;         % initially, 0 token in this place 

    % Add-ons for attributed hybrid dynamic nets
    Vplace.contdyn = []; % continuous dynamics
    
    global_Vplaces = [global_Vplaces Vplace];
end;

PN.global_Vplaces = global_Vplaces;
