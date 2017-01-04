function [sim_results] = firingseq(pni, ...
                            firing_sequence, repeat_seq, maximal_set)
%        [sim_results] = firingseq(pni, ...
%                           firing_sequence, repeat_seq, maximal_set)
% Name:	firing-sequence
% Purpose:	This is function allows a series of transitions 
%  to be extcuted in the given order. 
%  If the execution in the given order is not possible, 
%
%  This function is very similar to gpensim. 
%
% Input parameters:	
%       pni:             marked Petri Net 
%       firing-sequence:the firing sequence 
%       repeat_seq:     whether to repeat the firing seq or not 
%       maximal_set:    whether to allow parallel firings or not 
%                       (default: parallel firing not allowed)
%
% Out parameters:	Simulation results
%                   
% Uses:	max_loop, print_loop_nr, simulations_complete
%           enabled_transition
%           start_firing
%           complete_firing
%           global_timer_advancement
%           pack_sim_results
% Used by:	[main simulation file]
% Note:	Very similar to gpensim except that only the transitions 
%       in the firing_seq is allowed to fire
%       
% Example:
%   [sim_results] = firingseq(pni, {'t1','t2','t2'}, 1, 1);

%  Reggie.Davidrajuh@uis.no (c) Version 8.0 (c) 05 February 2014  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global PN;
PN = pni;    % pni is the global PetriNet structure with ini dyn.

global global_info;

repeating = false;
allow_parallel = false;

if eq(nargin,0), 
    gpensim_ver; return; % no inputs: print the version number and quit
elseif eq(nargin, 1),
    error('usage: firingseq(pni, firing_sequence)');
elseif eq(nargin, 3),
    repeating = repeat_seq; 
elseif eq(nargin, 4)
    repeating = repeat_seq; 
    allow_parallel = maximal_set;
end;

Transition_Series = zeros(1, length(firing_sequence));
for i = 1:length(firing_sequence),
    Transition_Series(i) = check_valid_transition(firing_sequence{i});
end;
TT = Transition_Series;   

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

    t1 = TT(1);
    
    t1_enabled = PN.Enabled_Transitions(t1);
    t1_firing = PN.Firing_Transitions(t1);
    any_firing = any(PN.Firing_Transitions);
    
    if allow_parallel, % parallel firing allowed
       t1_can_fire = and(t1_enabled, not(t1_firing)); 
    else
       t1_can_fire = and(t1_enabled, not(any_firing)); % parallel firing allowed
    end;
    
    if t1_can_fire,
        [EIP] = fire_trans(EIP, t1); 
        if (PN.Firing_Transitions(t1)), 
            TT = TT(2:end);
            if isempty(TT), 
                if repeating, 
                    TT = Transition_Series;
                else
                    global_info.STOP_SIMULATION = true;
                end;
            end;
        end;
    end;
    
    Firing_Trans_SET = [Firing_Trans_SET;        % ** NOTE: APOSTERORI **
        PN.current_time, PN.Firing_Transitions]; % set of firing trans
    FTS_index = FTS_index + 1;
    log_record = [PN.X, 0, 0, 0, 0, ...
        PN.current_time, PN.current_time, PN.VX];
    LOG = [LOG; log_record];
    % Continuous variables log
    LOG_RECORD = cont_record();
    LOG_CONT = [LOG_CONT; LOG_RECORD];
    
    % Now take a completed event in queue
    number_of_completions = 0; %for start, assume no completion this time 
    EIP_not_empty = ~isempty(EIP);
    if (EIP_not_empty),
        [LOG, colormap, EIP, number_of_completions] = ...
            firing_complete(LOG, colormap, EIP, FTS_index);
    end;
    
    % time to increase timer for the next loop
    timer_increment(number_of_completions);
    
    % stop if ((queue is empty) OR (max loop) OR (max log size)) is reached
    SIM_COMPLETE = simulations_complete(Loop_Nr, global_info.MAX_LOOP);
end; %while ~(SIM_COMPLETE)

% Finally, pack results
pack_sim_results(Enabled_Trans_SET, Firing_Trans_SET, LOG, colormap, LOG_CONT);

% finally, run the simulation
sim_results = PN;
