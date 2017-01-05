function [EIP]= fire_trans(EIP, t1)
% function [EIP]= fire_trans(EIP, t1)
%
% First generate random event order random_events
% Then check for enabled transitions, one by one
% If any enabled, compute token removal and deposits
% Put the transition in its respective place in queue
%

%  Reggie.Davidrajuh@uis.no (c) Version 6.0 (c) 10 july 2012  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global PN;
Rs = PN.No_of_system_resources;

if and(PN.Enabled_Transitions(t1),...  % enabled & not currently firing
     ~(PN.Firing_Transitions(t1))), 
 [fcs, new_color, override, new_part_No, selected_tokens, additonal_cost, split] = ...
     firing_preconditions(t1); 
 if fcs, % firing conditions satisfied, let the transition fire
     PN.Firing_Transitions(t1) = 1;  %          
     % token removals and computing deposits                    
     [delta_X,output_place,inherited_color,inherited_costs,...
        inherited_cont_var,inherited_part_No] = ...
         consume_tokens(t1, selected_tokens); 
            
     % assign any resources reserved by t1
     resource_usage_cost = 0;
     if (Rs), [resource_usage_cost] = resource_assign(t1); end; 
     
     output_token_cost = 0; % just to start
     if or(additonal_cost, PN.COST_CALCULATIONS), 
         [output_token_cost] = cost_of_output_token(t1, additonal_cost,...
             resource_usage_cost, inherited_costs);            
     end;
     % create new event to be put in Queue
     new_event_in_Q = create_new_event_in_Q(t1, ...
         delta_X, output_place);
     
     if (override), colorset = new_color; 
     else colorset = union(new_color,inherited_color);
     end;
     if ischar(colorset), colorset = {colorset}; end;

     new_event_in_Q.add_color = colorset;
     new_event_in_Q.add_cost  = output_token_cost;
     new_event_in_Q.add_cont_var = inherited_cont_var;
     if isempty(new_part_No),
         zero_No = find([inherited_part_No{:}] == '0');
         if zero_No,
            inherited_part_No{zero_No} = {};                    
            inherited_part_No = inherited_part_No(~cellfun(@isempty, inherited_part_No));
            new_event_in_Q.add_part_No = inherited_part_No;
        else
            new_event_in_Q.add_part_No = inherited_part_No; % union(new_part_No,inherited_part_No);
         end;                
     else
         new_event_in_Q.add_part_No = new_part_No;
     end;
     new_event_in_Q.split = split;

     EIP = add_to_events_queue(new_event_in_Q, EIP); % add to Queue         

 else % if firing conditions are NOT satisified 
     % cancel any resource reservations by the transition
     if (Rs), resource_unreserve(t1); end; % 
 end; % if fcs, 
end;