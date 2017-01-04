function [Dm, D] = matrixD
% function [Dm, D] = matrixD

global PN;

Ps = PN.No_of_places;
AA = PN.incidence_matrix;
Dm = AA(:, 1:Ps);
Dp = AA(:, Ps+1:end);
D = Dp - Dm;
