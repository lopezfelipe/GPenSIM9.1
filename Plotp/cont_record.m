function [LOG_RECORD] = cont_record()
%
% lopezfe@umich.edu Jan 1, 2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global PN;

LOG_RECORD = [];

for i = PN.cont_places,
    if ~isempty(PN.global_places(i).token_bank), % Check if there are tokens
        for j = 1:length(PN.global_places(i).token_bank), % For every token
            log_cont_record.time = PN.current_time;
            log_cont_record.tokID = PN.global_places(i).token_bank(j).tokID;
            for k = 1:length(PN.global_places(i).token_bank(j).cont_var)
                log_cont_record.cont_var ...
                    = PN.global_places(i).token_bank(j).cont_var(k);
                log_cont_record.var_label = strcat(PN.global_places(i).name,num2str(k));
                log_cont_record.part_No = PN.global_places(i).token_bank(j).part_No;
                for l = 1:length(PN.global_places(i).token_bank(j).part_No)
                    log_cont_record.part_No = PN.global_places(i).token_bank(j).part_No{l};
                    LOG_RECORD = [LOG_RECORD; log_cont_record];
                end;                    
            end;               
        end;
    end;
end