function [PN] = add_slacks_to_global_places(PN, lenConstr)
%        [PN] = add_slacks_to_global_places(PN, lenConstr)


slack_places = [];

for i = 1:lenConstr,
    slack_pl.name = ['slack' int2str(i)]; slack_pl.tokens = 0;
    slack_places = [slack_places slack_pl]; 
end;

PN.global_places = [PN.global_places slack_places];
PN.No_of_places = PN.No_of_places + lenConstr;
PN.No_of_control_places = lenConstr;
