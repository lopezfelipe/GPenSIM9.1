function [acquired] = requestWR(trans_name, resource_name)
%        [acquired] = requestWR(trans_name, resource_name)

%  Reggie.Davidrajuh@uis.no (c) Version 6.0 (c) 10 july 2012  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global PN;

if iscell(resource_name), resource_name = resource_name{1}; end;

t_index = check_valid_transition(trans_name);
r_index = check_valid_resource(resource_name);

no_of_instances_required = PN.system_resources(r_index).max_instances;

[acquired] = resource_request_one_res(t_index, r_index, ...
                       no_of_instances_required);
