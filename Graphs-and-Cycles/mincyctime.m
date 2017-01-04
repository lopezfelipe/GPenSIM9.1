function [V] = mincyctime(pni)
% function [V] = minicyctime(pni)
%        minim-cycle-time 
% This function finds the "minim-cycle-time (MCT)" of a marked graph.
% In order to find MCT, this function first lists all the cycles 
% in a marked_graph. The MCT = max(cycle Delay/tokens in the cycle)
% 
%
% This function first checks whether the PN is a mrked_graph.
% If not, it simply exits with an error message.
% If this is a marked graph, 
%  1) PN (incidence matrix) is converted into 
%       standard V (adjancency matirx) for graph algorithms 
%       using the function "convert_PN_V"
%  2) all the cycles are found using the function "cycles.m"
%  
%       Reggie.Davidrajuh@uis.no (c) December 2011

[classtype] = pnclass(pni);
if not(classtype(3)), % png is is NOT a marked graph
    disp('This is not a marked graph ....'); V = [];
    return;
end;

V1 = convert_PN_V(pni);
V = cycles(V1);

No_of_nodes = length(V.nodes);
Ps = pni.No_of_places;
Ts = pni.No_of_transitions;
if not(eq(No_of_nodes, Ps+Ts)),
    error('"No_of_nodes" NOT equal to "pni.Ps + pni.Ts"');
end;

% init each node with imarkings and firing_time 
for i = 1:Ts,
    V.nodes(i).imarkings = 0; 
    V.nodes(i).firing_time = pni.Set_of_Firing_Times(i);
end;

for i = Ts+1:No_of_nodes,
    V.nodes(i).imarkings = pni.X(i-Ts); 
    V.nodes(i).firing_time = 0;
end;

% now print: cycle number, cycle path, total Time delay, token sum, CT
print_minimum_cycle_time(V);
