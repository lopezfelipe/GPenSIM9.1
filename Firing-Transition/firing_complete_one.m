function [log_record, colormap_record] = firing_complete_one...
                        (current_event, FTS_index)
% function[log_record, colormap_record] = firing_complete_one ...
%                       (current_event, FTS_index)
%

%  Reggie.Davidrajuh@uis.no (c) Version 6.0 (c) 10 july 2012  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



global PN;
Ps = PN.No_of_places;

t1 = current_event.event; % firing transition

% deposit new tokens
delta_X = current_event.delta_X;
PN.X    = PN.X + delta_X;

% check that split is possible
if ( current_event.split && ( sum(delta_X) ~= ...
        ( length(current_event.add_color) - ...
        sum(cell2mat(cellfun(@isempty,current_event.add_color,'uni',false)))))),
    error('Not able to split colors');
end;

% cancel virtual tokens in Virtual Places
PN.VX = PN.VX - PN.global_transitions(t1).absorbed_tokens;
PN.global_transitions(t1).absorbed_tokens = zeros(1, Ps);

for i = 1:length(delta_X),
    if delta_X(i),
        if ~current_event.split,
            deposit_token(i,delta_X(i), ...
                current_event.add_color, current_event.add_cost, ...
                current_event.add_cont_var, current_event.add_part_No);
        else
            % Check if there is a color assigned for that position
            destinations = find( PN.incidence_matrix(t1,PN.No_of_places+1:end) == 1 );
            if all( i ~= destinations),
                error ('Trying to assign split color to a wrong destination');
            end;
            % Assign color
            deposit_token(i,delta_X(i), ...
                current_event.add_color(i), current_event.add_cost, ...
                current_event.add_cont_var, current_event.add_part_No(i));
        end;
    end;
end;      

PN.global_transitions(t1).times_fired = ...
    PN.global_transitions(t1).times_fired + 1;
PN.State = PN.State + 1;

log_record = [PN.X, t1, PN.State, current_event.from_State, ...
    FTS_index, current_event.start_time, PN.current_time PN.VX];

% after all the deposits, now get the colors picture in color_map 
colormap_record = get_current_colors();

% finally perform, if any, post actions of the firing 
firing_postactions(t1); 

%%%%%%%%%%%%
% trans has fired thus available
PN.Firing_Transitions(t1) = 0; 
