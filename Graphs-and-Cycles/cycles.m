function [V] = cycles(V)
% function [V] = cycles(V)
%  
%       Reggie.Davidrajuh@uis.no (c) December 2011

No_of_nodes = length(V.nodes);
vertex_order = 1:No_of_nodes;
V.cycles = [];

% detect all the cycles
% cycles are return as "V.cycles"

%disp('Inside "cycles(V)" ....');

for i = 1:No_of_nodes,
    %disp(['vertex_order: ',int2str(vertex_order)]);
    vertex_order = circshift(vertex_order', 1)';
    %disp(['vertex_order: ',int2str(vertex_order)]);
    V = cycle_detection(V, vertex_order);
end;

