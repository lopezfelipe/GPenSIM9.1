function [r_index] = check_valid_resource(resource)
% function [r_index] = check_valid_resource(resource)
% checks whether resource name is valid

%  Reggie.Davidrajuh@uis.no (c) Version 6.0 (c) 10 july 2012  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global PN;

if ischar(resource),   % resource is a character string name
    r_index = search_names(resource, PN.system_resources);
    if not(r_index),
        error([resource, ':  unknown resource']);
    end;    
else
    r_index = resource;  % resource is an index  
end;

