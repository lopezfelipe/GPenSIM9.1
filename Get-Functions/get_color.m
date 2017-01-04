function [colors] = get_color(pi, tokID)
% [colors] = get_color (pi, tokID)
% get the color of the token
% token must be identified by the (place_name, tokID) pair 
%      or (place_index, tokID) pair

global PN;

%disp('inside "get_color" ....'); 

if ischar(pi), pi = check_valid_place(pi); end;
t_bank = PN.global_places(pi).token_bank;

if isempty(t_bank), 
    error('given tokID is not valid');
end;

tokIDs = [t_bank.tokID];
[i, j] = ismember(tokID, tokIDs);
if not(i), 
    error('given tokID is not in given place');
end;
colors = t_bank(j).color;




% 
% pj = 1;
% while and((pj <= Ps), any(set_of_tokID)),
%     tbank = PN.global_places(pj).token_bank;
%     for kb = 1: length(tbank),
%         member_index = ismember(set_of_tokID, tbank(kb).tokID);
%         if any(member_index),
%             set_of_color = union(set_of_color, tbank(kb).color);
%             set_of_tokID(member_index)= 0; 
%         end;
%     end;
%     pj = pj + 1;
% end;
