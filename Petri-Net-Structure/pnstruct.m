function [PN] = pnstruct(fileNames) 
% [PN] = pnstruct(set_of_files)
%
% E.g.: PN = pnstruct('test0506_def');
%
% This function reads the petri net definition file(s), which
% is identified by the input filename. Then, it creates 
% the structure for the Petri net.
% Define variables: 
% Inputs: PN_def_filename(s)
% Output: PN: The Petri net structure
% Functions called : build_place, build_trans, 
%                    incidencematrix 
%                      
 
%  Reggie.Davidrajuh@uis.no (c) Version 6.0 (c) 10 july 2012  
%  renamed "pnstruct" from "petrinetgraph" 15 November 2013 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global PN; % because of incidencematrix() 

%%%% for single definition file %%%%%
if ischar(fileNames), fileNames = {fileNames}; end;

No_of_files = length(fileNames);
global_set_of_Ps = []; global_set_of_Ts = []; global_set_of_As = [];
global_set_of_Is = [];  % inhibitor arcs

for i=1:No_of_files,
    funcname = char(fileNames(i)); 
    filename = [funcname '.m'];
    check_valid_file(filename);

    [png] = feval(str2func(funcname));
    global_set_of_Ps = [global_set_of_Ps png.set_of_Ps]; 
    global_set_of_Ts = [global_set_of_Ts png.set_of_Ts];
    global_set_of_As = [global_set_of_As png.set_of_As];
    if isfield(png, 'set_of_Is'), 
        global_set_of_Is = [global_set_of_Is png.set_of_Is];
    end;
end;

global_set_of_Ps = unique(global_set_of_Ps);
Ps = length(global_set_of_Ps);
global_set_of_Ts = unique(global_set_of_Ts); 
Ts = length(global_set_of_Ts);

PN.name = png.PN_name;
PN.global_places = png_places(global_set_of_Ps);
PN.No_of_places = Ps; 
PN.global_transitions = png_trans(global_set_of_Ts, Ps);
PN.No_of_transitions = Ts; 

PN = png_Vplaces(PN);
png_incidencematrix(global_set_of_As);
png_inhibitormatrix(global_set_of_Is);

