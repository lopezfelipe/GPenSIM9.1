function [sim_results] = gpensim(pni)
%        [sim_results] = gpensim(pni)
% Name:	gpensim
% Purpose:	This is the main M-function for Petri net simulation.
%           Inside the main loop, transitions are randomly chosen and
%           checked whether they are enabled or not.
%           If they are enabled, the token removal and deposition happens
%           in respective places. Then the happenings are recorded
%           in the simulation results LOG.
%
% Input parameters:	Petri net structure with ini dynamics
%                   global_info
% Out parameters:	Simulation results
%                   global info
% Uses:	max_loop, print_loop_nr, simulations_complete
%           enabled_transition
%           start_firing
%           complete_firing
%           global_timer_advancement
%           pack_sim_results
% Used by:	[main simulation file]
% Note:	This is one of the most important M-files,
%       as it realizes the main simulation loop
% Example:
%   [sim_results] = gpensim(pni);

%  Reggie.Davidrajuh@uis.no (c) Version 6.0 (c) 10 july 2012  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% if no inputs, then print the version number and quit. 
if (nargin==0), gpensim_ver; return; end;

global PN;
PN = pni;    % pni is the global PetriNet structure with ini dyn.

global global_info;

% initialize all the variables
[Ts,EIP,LOG, colormap,Enabled_Trans_SET, ...
    Firing_Trans_SET,SIM_COMPLETE,Loop_Nr, ETS_index, FTS_index] = ...
            gpensim_init_all();

% Find all continuous places
PN.cont_places = [];
for i=1:PN.No_of_places
    if (~isempty(PN.global_places(i).contdyn)), PN.cont_places = [PN.cont_places i]; end;
end;
LOG_CONT = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%  MAIN LOOP   %%%%%%%%%%%%%%%%%%%%%%%%%%

while ~(SIM_COMPLETE), 
    Loop_Nr = Loop_Nr + 1;
    if global_info.PRINT_LOOP_NUMBER,
        disp(['Loop: ',int2str(Loop_Nr)]); %'Time:',num2str(PN.current_time)]);        
    end;
    
    for i = 1:Ts, PN.Enabled_Transitions(i) = enabled_transition(i); end;
    
    Enabled_Trans_SET = [Enabled_Trans_SET;       % ** NOTE: APRIORI **
        PN.current_time,PN.Enabled_Transitions];  % set of enabled trans
    ETS_index = ETS_index + 1; 
    
    %NGT: ***************************************************************
     if any(PN.Enabled_Transitions),  [EIP] = firing_start(EIP); end;
    %NGT: ***************************************************************
    
    Firing_Trans_SET = [Firing_Trans_SET;        % ** NOTE: APOSTERORI **
        PN.current_time, PN.Firing_Transitions]; % set of firing trans
    FTS_index = FTS_index + 1;
    % Discrete event system log
    log_record = [PN.X, 0, 0, 0, 0, ...
        PN.current_time, PN.current_time, PN.VX];
    LOG = [LOG; log_record];
    % Continuous variables log
    LOG_RECORD = cont_record();
    LOG_CONT = [LOG_CONT; LOG_RECORD];
    
    % Now take a completed event in queue
    number_of_completions = 0; %for start, assume no completion this time 
    EIP_not_empty = ~isempty(EIP);
    
    if isfield(global_info, 'COMPARE')
        if ( global_info.COMPARE ),
            if (Loop_Nr == 1),
                SimPLCinputs = global_info.PLCinputs;
                SimPLCcoils = global_info.PLCcoils;
                SimPLCtime = PN.current_time;
            else
                SimPLCinputs = [SimPLCinputs; global_info.PLCinputs];
                SimPLCcoils = [SimPLCcoils; global_info.PLCcoils];
                SimPLCtime = [SimPLCtime; PN.current_time];
            end;
        end;
    end;
    
    if (EIP_not_empty),
        %NGT: *************************************************************        
        [LOG, colormap, EIP, number_of_completions] = ...
            firing_complete(LOG, colormap, EIP, FTS_index);
        %NGT: *************************************************************
    end;
    
    % time to increase timer for the next loop
    timer_increment(number_of_completions);
    
    % stop if ((queue is empty) OR (max loop) OR (max log size)) is reached
    SIM_COMPLETE = simulations_complete(Loop_Nr, global_info.MAX_LOOP);           
end; %while ~(SIM_COMPLETE)

% Finally, pack results
pack_sim_results(Enabled_Trans_SET, Firing_Trans_SET, LOG, colormap, LOG_CONT);
% Pack PLC predictions
if isfield(global_info, 'COMPARE')
    if ( global_info.COMPARE ),
        PLCprediction.time = SimPLCtime;
        PLCprediction.inputs = SimPLCinputs;
        PLCprediction.coils = SimPLCcoils;
        PN.PLCprediction = PLCprediction;
    end;
end;

% finally, run the simulation
sim_results = PN;


                