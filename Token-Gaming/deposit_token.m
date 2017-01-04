function [] = deposit_token(placeI, nr_tokens, t_color, t_cost, t_cont_var,...
    t_part_No)
% [] = deposit_token(placeI, nr_tokens, t_color, t_cost, t_part_No)
%
%               Reggie Davidrajuh (c) Sep 2012
%%%%%%%%%%%%%%%%%%%%

global PN;

PN.global_places(placeI).tokens = ...
    PN.global_places(placeI).tokens + nr_tokens; 

for i = 1:nr_tokens,
    PN.token_serial_numer = PN.token_serial_numer + 1;
    tok.tokID = PN.token_serial_numer;
    tok.creation_time = PN.current_time;
    tok.token_time = PN.current_time;
    tok.color = t_color;     
    tok.cost = t_cost;
    tok.part_No = t_part_No;
    tok.cont_var = {};
    % Initialize constant variable (hybrid simulation)
    if ~isempty(PN.global_places(placeI).contdyn)
        tok.cont_var = feval(horzcat(PN.global_places(placeI).contdyn,'_init'),t_cont_var);
    end;
    PN.global_places(placeI).token_bank = ...
        [PN.global_places(placeI).token_bank tok];
end;
