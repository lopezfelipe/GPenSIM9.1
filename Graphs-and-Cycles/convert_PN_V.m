function [V] = convert_PN_V(PN)
% function [V] = convert_PN_V(PN)
% This function converts PN.incidence_matrix (A) 
% into V (adjacency matrix) so that standard graph algorihms 
% such as Depth-First-Search  can be used. 
%  
%       Reggie.Davidrajuh@uis.no (c) December 2011

Ps = PN.No_of_places;
Ts = PN.No_of_transitions;

A = PN.incidence_matrix;

inputPs = A(:, 1: Ps);
outputPs = A(:, Ps+1:end);

% Adjacency_Matrix: 
%  Adj = [zeros(Ts)| outputPs  ]
%        [inputPs' |  zeros(Ps)]

Tm0 = zeros(Ts, Ts);
Pm0 = zeros(Ps, Ps);

V.A = [Tm0, outputPs; inputPs', Pm0];

nodes = [];

for i=1:Ts,
    nodeI.name = PN.global_transitions(i).name;
    nodes = [nodes nodeI];
end;

for i=1:Ps,
    nodeI.name = PN.global_places(i).name;
    nodes = [nodes nodeI];
end;
V.nodes = nodes;

