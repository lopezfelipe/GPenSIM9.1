function [] = advance_continuous_places()

global PN

% Advance time in continuous places
for placeI = PN.cont_places
    ntokens = length(PN.global_places(placeI).token_bank);
    % If tokens present, integrate their continuous states
    for i = 1:ntokens
        % Check if continuous time has passed
        if ( current_time() > PN.global_places(placeI).token_bank(i).token_time ),
            [t_array,cont_var_array] = ode15s(PN.global_places(placeI).contdyn,...
                [PN.global_places(placeI).token_bank(i).token_time current_time()],...
                PN.global_places(placeI).token_bank(i).cont_var);
            PN.global_places(placeI).token_bank(i).cont_var = ...
                cont_var_array(end,:);
            PN.global_places(placeI).token_bank(i).token_time = t_array(end);
        end;
    end;
end;

end