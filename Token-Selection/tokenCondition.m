function [set_of_tokID, nr_token_av] = tokenCondition(placeI, ...
                         nr_tokens_wanted, index, limit)
%function [set_of_tokID, nr_token_av] = tokenCondition(placeI, ...
%                         nr_tokens_wanted, cont_var, limit)
%
% Selection of tokens from a specific place when a continuous variable goes
% greater or equal than a user-derfined limit:
% e.g. Select one token from place 'p1' when its first continuous variable
% x goes above 10
%    tokenCondition('p1',1,1,10)

%  lopezfe@umich.edu  Dec 26, 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global PN;

% if place is a string, then get the place index
if ischar(placeI), placeI = check_valid_place(placeI); end;

set_of_tokID = zeros(1, nr_tokens_wanted); % all zeros, initially
nr_token_av = 0; % initially
nr_tokens_in_placeI = PN.global_places(placeI).tokens;

% if the place has no tokens then there's nothing to do
if not(nr_tokens_in_placeI), return; end; 

tbank = PN.global_places(placeI).token_bank;
for i = 1:nr_tokens_in_placeI,
    if ( tbank(i).cont_var(index) >= limit-1.0e-6 )
        nr_token_av = nr_token_av + 1;
        set_of_tokID(nr_token_av) = tbank(i).tokID;
    end;
    if eq(nr_token_av, nr_tokens_wanted),
        break; 
    end;
end;