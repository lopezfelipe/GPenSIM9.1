function [] = pack_sim_results(Enabled_Trans_SET, Firing_Trans_SET, ...
                        LOG, colormap, LOG_CONT)
% function [] = pack_sim_results(Enabled_Trans_SET, Firing_Trans_SET, ...
%                        LOG, colormap)

%  Reggie.Davidrajuh@uis.no (c) Version 6.0 (c) 10 july 2012  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global PN;

%Ps = PN.No_of_places;      % number of places
Ts = PN.No_of_transitions; % number of tansitions

% final enabled trans
for i = 1:Ts, PN.Enabled_Transitions(i)=enabled_transition(i); end;

Enabled_Trans_SET = [Enabled_Trans_SET;       % *** NOTE: APOSTERORI ***
    PN.current_time, PN.Enabled_Transitions]; % LOG global set of enabled 
Firing_Trans_SET = [Firing_Trans_SET;
    PN.current_time, PN.Firing_Transitions]; % global set of enabled     

% Pack the results
PN.LOG = LOG;
% If running a hybrid simulation
%if PN.cont_places,
if ~isempty(PN.cont_places) && ~isempty(LOG_CONT),
    % Look for unique continuous variables
    LOG_CONT_s = cellfun(@(x)(mat2str(x)),struct2cell(LOG_CONT),'uniformoutput',false);
    [uniqueCells1,~,idxYouWant1] = unique(LOG_CONT_s(4,:,1));
    % For each continuous variable
    for i = 1:length(uniqueCells1)
        struct_index = LOG_CONT(idxYouWant1 == i);
        % Look for unique part numbers
        struct_index_s = cellfun(@(x)(mat2str(x)),struct2cell(struct_index),'uniformoutput',false);
        % Label by part number or by token numer (part_No not used)
        if isfield(struct_index,'part_No'),
            [uniqueCells2,~,idxYouWant2] = unique(struct_index_s(5,:,1));
        else
            [uniqueCells2,~,idxYouWant2] = unique(struct_index_s(2,:,1));
        end;
        for j = 1:length(uniqueCells2)
            struct_index2 = struct_index(idxYouWant2 == j);
            if isfield(struct_index,'part_No'),
                if ~isempty(uniqueCells2{j}),
                    token_name = strcat('partNo',uniqueCells2{j}(2:end-1));
                else token_name = 'NoNumber';
                end;
            else
                token_name = strcat('tokenNo',uniqueCells2{j});
            end;
            CONT_VAR.(uniqueCells1{i}(2:end-1)).(token_name) ...
                = horzcat(cat(1,struct_index2.time) , ...
            cat(1,struct_index2.cont_var) );
        end;
    end;
    PN.LOG_CONT = CONT_VAR;
    clearvars LOG_CONT_s struct_index struct_index_s struct_index2;
end;
PN.Firing_Trans_SET = Firing_Trans_SET;
PN.Enabled_Trans_SET = Enabled_Trans_SET;
PN.color_map = colormap;
PN.completion_time = PN.current_time;
PN.overall_no_of_tokens_used = PN.token_serial_numer;
%PN.final_tokens = get_all_tokens;
