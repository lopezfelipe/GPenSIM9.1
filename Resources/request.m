function [acquired] = request(trans_name, specific_resources)
% function [acquired] = request(trans_name, specific_resources)
% Input-1: Name of the transition requiring resource e.g. 't1'
% Input-2: set of resources. e.g. {'Nuts',2, 'Bolts',3} 
% Output: true or false, if reservation was successfull or not
%
% E.g.  acq = request('t1'); % t1 wants any one resources
%       acq = request('t1', {'Nuts',2, 'Bolts',3}); % t1 wants 2 nuts and 3 bolts

%  Reggie.Davidrajuh@uis.no (c) Version 6.0 (c) 10 july 2012  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%disp(['inside "resource_request" ....']);

global PN;

acquired = false; % initially 
t_index = check_valid_transition(trans_name);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% nargin == 1: reserve ANY ONE available resource
if eq(nargin, 1),  
    r_index = 1;
    Rs = PN.No_of_system_resources;
    found = false;
    while and(le(r_index, Rs), not(found)),
        found = resource_request_one_res(t_index, r_index, 1);
        r_index = r_index + 1;
    end;
    acquired = found;    
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% nargin == 2: reserve ONE or multiple specific resource(s)
if eq(nargin, 2),  
    no_of_resources = length(specific_resources)/2;
    
    acquired = true; % inital assumption
    for i = 1: no_of_resources,
        res_name = specific_resources{2*i-1};
        r_index = check_valid_resource(res_name);
        no_of_instances = specific_resources{2*i};
        found = resource_request_one_res(t_index, ...
                             r_index, no_of_instances);
        acquired = and(acquired, found);
    end;
end;

