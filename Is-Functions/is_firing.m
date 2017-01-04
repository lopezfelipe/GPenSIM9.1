function [firing_or_not] = is_firing(transition1)
% function [firing_or_not] = is_firing(transition1)

global PN;

%if t is name then convert into number
if ischar(transition1),
    transition1 = is_trans(transition1);
end;

firing_or_not = PN.Firing_Transitions(transition1);

