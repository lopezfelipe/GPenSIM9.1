function [] = prnfinalcolors(Sim_Results, set_of_places)
% [] = prnfinalcolors (Sim_Results, set_of_places)
% 
% Name:	print_finalcolors
% Purpose:	To print colors of the final state 
%           (colors of the tokens that are left in the system 
%           when the simulations are complete)
% Input parameters:	Simulation Results (the structure output by ‘gpensim’)
% Out parameters:	None
% Uses:	None
% Used by:	[main simulation file]
% Example:	
%   % in main simulation file
%   results = gpensim(pn, dynamicpart);
%   print_finalcolors(results); 

disp(' '); disp(' ');
disp('Colors of Final Tokens:'); 

if eq(nargin, 2),
    set_of_pi = [];
    for i = 1:length(set_of_places),
        pi = set_of_places{i};
        if ischar(pi), pi = check_valid_place(pi); end;
        set_of_pi = [set_of_pi pi];
    end;
else
    set_of_pi = 1:Sim_Results.No_of_places;
end;

for i = 1:length(set_of_pi),
    pi = set_of_pi(i);
    t_bank = Sim_Results.global_places(pi).token_bank;
    place_name = Sim_Results.global_places(pi).name;
    if not(isempty(t_bank)),
        for j = 1:length(t_bank),
            token = t_bank(j);
            ctime = token.creation_time;
            colors = token.color; 
            [m, n] = size(colors);
            colorset = ' '; for k = 1:m, colorset = [colorset, ' ', colors{k}]; end;
            cost = token.cost;
            if isempty(colors),
                disp_str = ['Time: ',num2str(ctime),'    Place: ', place_name,...
                    ' *** NO COLOR ***'];
            else
                disp_str = ['Time: ',num2str(ctime),'    Place: ', place_name,...
                    '    Colors: ', colorset];
            end; % if isempty(colors),
            if cost,
                disp_str = [disp_str,  '   Cost: ', num2str(cost)];
            end;
            disp(disp_str);
            
        end; % for j = 1:length(t_bank),
    end; % if not(isempty(t_bank)), 
end;
   
