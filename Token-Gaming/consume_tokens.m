function [delta_X,index_OP,inherited_color_set,inherited_costs,inherited_cont_var,...
    inherited_part_No_set] = consume_tokens (transition, selected_tokID)
% [delta_X,index_OP,inherited_color_set,inherited_costs] = ...
%                 consume_tokens(trans,selected_tokID)
% This function takes care of removing tokens from input places and 
% computing deposits on the output place when an enabled transition fires.
%
% Inputs:     transition - a given transtion 
%             X: intial marking (state of system at any given time)
% Outputs:    X: number of tokens remaining at the input place after-
%                       removal of token
%             delta_X:  weight output arcs;  
%             index_op: index of output places
%

%  Reggie.Davidrajuh@uis.no (c) Version 7.0 (c) 30 july 2012  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global PN;

Ps = PN.No_of_places;
A =  PN.incidence_matrix; 

%token removals from input place
input_weigths = A(transition,1:Ps); %extracting the weight of input arcs 
inherited_color_set = {};
inherited_costs = 0;
inherited_cont_var = [];
inherited_part_No_set = {};

% Move input tokens into Virtual places as "virtual tokens" 
PN.X  = PN.X  - input_weigths;   % take tokens from input places ...
PN.VX = PN.VX + input_weigths; %   and push into Virtual places

PN.global_transitions(transition).absorbed_tokens = input_weigths;
%disp(['PN.global_transitions(transition).absorbed_tokens : ', ...
%    int2str(PN.global_transitions(transition).absorbed_tokens)]);  


for i = 1:Ps,
    tokens_to_be_consumed = input_weigths(i);
    if (tokens_to_be_consumed),
        [inherited_color_from_pi, inherited_costs_pi, selected_tokID, ...
            inherited_cont_var_pi, inherited_part_No_from_pi] = ...
            consume_token_in_place_i ...
            (i, tokens_to_be_consumed, selected_tokID); 
        % inherit colors and costs from different places 
        inherited_color_set = union(inherited_color_set, ...
            inherited_color_from_pi);        
        inherited_costs = inherited_costs + inherited_costs_pi;
        inherited_cont_var = horzcat(inherited_cont_var, ...
            inherited_cont_var_pi);
        inherited_part_No_set = union(inherited_part_No_set, ...
            inherited_part_No_from_pi);  
    end;
end;

output_weights = A(transition, Ps+1:2*Ps); %extracting output arc weights
index_OP = any(output_weights, 1); % index of output place
delta_X = output_weights;  % tokens to be deposited into output places
