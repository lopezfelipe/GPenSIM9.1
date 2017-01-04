function [Pre_A, Post_A, D] = gpensim_2_PNCT(PN)
% function [Pre_A, Post_A, D] = gpensim_2_PNCT(PN)
% 
% convert GPenSIM PN structure into 
%           "Cagliari "Petri Net Control Toolbox" structure

%   Reggie.Davidrajuh@uis.no (c) Version 6.0 (c) July 2012 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

A = PN.incidence_matrix;
Ps = PN.No_of_places;

Pre_A  = A(:, 1:Ps)';       % Pre  places
Post_A = A(:, Ps+1:2*Ps)';  % Post places 
D = Post_A - Pre_A;         % Incidence Matrix