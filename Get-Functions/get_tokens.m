function [set_of_tokens] = get_tokens(pi, tokenIDs)
% function [set_of_tokens] = get_tokens(pi, tokenIDs)
% get complete token information 
%              input parameter-1: pi (place name or place index)
% (optional)   input parameter-2: set of tokIDs
%  if input parameter-2 is not given, then all the tokens 
%       in the the place pi will be returned

global PN;

set_of_tokens = [];

if ischar(pi),  pi = check_valid_place(pi); end;
if eq(nargin, 1), tokenIDs = tokIDs(pi); end;
if isempty(tokenIDs), return; end; 

for i = 1:length(tokenIDs),
    token_info = PN.global_places(pi).token_bank;
    set_of_tokens = [set_of_tokens token_info];
end;
