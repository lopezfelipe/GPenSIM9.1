function [classtype] = pnclass(png)
% function [classtype] = pnclass(png)
%       PetriNetClass
% This function checks the class of Petri net:
%       Binary PN?
%       PN State Machine?
%       Marked Graph (Event Graph)
%
% output variable classtype
%       bit-1: Binary PN
%       bit-2: PN State Machine
%       bit-3: Marked (Event) Graph
%
%       Reggie Davidrajuh (c) January 2012
%

Ps = png.No_of_places;  Ts = png.No_of_transitions;
A = png.incidence_matrix;
classtype = zeros(1, 8);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check for Binary PN
max_arc_weight = max(max(A));
if eq(max_arc_weight, 1),
    disp('This is a Binary Petri Nets');
    classtype(1) = 1; % set flag for Binary Petri Nets
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check for PN State Machine
% In a PN State Machine, every transition has exactly 
%     one input and one output place
Ainn = A(:, 1:Ps);  Aout = A(:, Ps+1:2*Ps);
PNSM = 1; % initial assumption
i = 1;
while and(le(i, Ts), PNSM),
    rowinn = Ainn(i,:);    rowout = Aout(i,:);
    no_of_input_places = length(find(rowinn));
    no_of_output_places = length(find(rowout));
    PNSM = and(eq(no_of_input_places, 1), eq(no_of_output_places, 1));
    i = i + 1;
end;

if PNSM, 
    disp('This is a Petri Net State Machine');
    classtype(2) = 1; % set flag for Petri Net State Machine
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check for Marked Graph (Event Graph)
% In a Marked Graph (Event Graph), every place has exactly 
%     one input and one output transition
AinnT = Ainn';  AoutT = Aout';
PNMG = 1; % initial assumption
i = 1;
while and(le(i, Ps), PNMG),
    rowinn = AinnT(i,:);    rowout = AoutT(i,:);
    no_of_input_Ts = length(find(rowinn));
    no_of_output_Ts = length(find(rowout));
    PNMG = and(eq(no_of_input_Ts, 1), eq(no_of_output_Ts, 1));
    i = i + 1;
end;

if PNMG, 
    disp('This is a Marked (Event) Graph');
    classtype(3) = 1; % set flag for Marked (Event) Graph
end;
