function [TOKEN_MATRIX] = plotp(sim_results, set_of_places, ...
                            plotCOLOR, plotLINEWIDTH)
%        [TOKEN_MATRIX] = plotp(sim_results, set_of_places, ...
%                           plotCOLOR, plotLINEWIDTH)
%
% Purpose:	To plot simulation results;  to plot how tokens change with time 
% Input parameters:	Simulation Results (the structure output by ‘gpensim’)
%                   {set_of_place_names}
%                   global_info (optional)
% Out parameters:	TOKEN_MATRIX (contains tokens of places with time)
% Uses:	extractp  (extracts tokens from the SIM results structure)
% Used by:	[main simulation file]
% Example:	
%   % in main simulation file
%   sim = gpensim(png, dynamic);
%   plotp(sim, {'p1','p2','p3'}, 'r', 10); 

%  Reggie.Davidrajuh@uis.no (c) Version 6.0 (c) 10 july 2012  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global PN;
PN = sim_results;

TOKEN_MATRIX = extractp(set_of_places);
[nr_rows, nr_columns] = size(TOKEN_MATRIX);

today = clock;

time_series = TOKEN_MATRIX(2:nr_rows,1); %skip place indice
TOKENS = TOKEN_MATRIX(2:nr_rows,2:nr_columns); %ONLY TOKENS

xunits = 'Time'; % initially
if isfield(PN, 'HH_MM_SS'),
    if (PN.HH_MM_SS),
        if gt(PN.completion_time, 60*60),
            xunits = [xunits ' in HOURS']; 
            time_series = time_series/(60*60);
        elseif gt(PN.completion_time, 60),
            xunits = [xunits ' in MINUTES']; 
            time_series = time_series/60;
        else
            xunits = [xunits ' in SECS'];
        end; % if gt(sim_results.completion_time
    end; % (sim_results.HH_MM_SS),
end; % isfield(sim_results,HH_MM_SS)

p = plot(time_series, TOKENS,... % DEFAULT:: linewidth=.5, MarkerSize=10
    '-h', 'linewidth', 0.5, 'MarkerSize', 5); 
if ge(nargin, 3), 
    if (plotCOLOR), set(p, 'color', plotCOLOR); end;
end;
if eq(nargin, 4), set(p, 'LineWidth', plotLINEWIDTH); end;

grid on; legend(set_of_places); xlabel(xunits); ylabel('Number of tokens');
