function [RES_USAGE] = print_schedule_pLOG(PN)
% function [RES_USAGE] = print_schedule_pLOG(PN)
% function [RES_USAGE] = print_schedule_process_LOG_file(PN) 
%
% output: 
%   RES_USAGE summary: [number_of_resources X 2] matrix
%       column-1: number of times each resource was used. 
%       column-2: total time of usage of each resource 

%
%  Reggie.Davidrajuh@uis.no (c) Version 6.0 (c) 10 August 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

res = PN.system_resources;
Rs = PN.No_of_system_resources;
LOG = PN.Resource_usage_LOG;

[rows] = size(LOG, 1); 
RES_USAGE = zeros(Rs, 2);  % [(No of times used, Station Time) for each resource]: 
disp('  '); disp('RESOURCE USAGE: ');

% IMPORTANT: LOG file row
% [resource, transition, start_time, end_time, resource_instance]   
for current_res = 1:Rs, % no_of_resources,
    res_name = res(current_res).name; 
    disp('  '); disp(['RESOURCE INSTANCES OF ***** ', res_name, ' *****']);
    max_instances = PN.system_resources(current_res).max_instances;
    res_instances_usage = zeros(2, max_instances); % [no of times used; total time used]
    
    for i = 1:rows,
        if eq(LOG(i,1), current_res),
            % display:  transition name  start_time end_time
            transition_name = PN.global_transitions(LOG(i, 2)).name; 
            start_time = LOG(i,3);  end_time   = LOG(i,4);
            task_time = end_time - start_time;
            res_instance = LOG(i,5);
            res_instances_usage(1, res_instance) = ...
                res_instances_usage(1, res_instance) + 1;
            res_instances_usage(2, res_instance) = ...
                res_instances_usage(2, res_instance) + task_time;            
            
            % !!!!!!!!!!task_time can be zero
            if (task_time),  % task_time is not zero
                % print_schedule_pLOG_print_each_resource_instance_firing
                print_schedule_pLOG_pERIF(max_instances,transition_name,...
                    res_name, res_instance, start_time, end_time);
            end; % if (task_time),  
        end; % if eq(LOG(i,1), current_res),
    end; % for i = 1:rows, 
    
    % summarize
    % print summary for each resource
    print_schedule_pLOG_pS4ER(max_instances,res_name,res_instances_usage);
    
    % res_instances_usage
    total_firings =  sum(res_instances_usage(1, :));  
    total_time = sum(res_instances_usage(2, :));  
    RES_USAGE(current_res, 1) = total_firings;
    RES_USAGE(current_res, 2) = total_time;
    %disp([res_name, ':  Total firings: ', num2str(total_firings)]); 
    %disp([res_name, ':  Total Time spent: ', num2str(total_time)]); 
end;
