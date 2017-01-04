function [COTREE] = cotree(pni, plot_ct, print_ct)   
%        [COTREE] = cotree(pni, plot_ct, print_ct)   
% Name:	cotree
% Purpose:	Creates the coverability tree of a Petri net 
%           and then print and plot it
% Input parameters:	
%  cotree takes three input arguments (parameters)'); 
%  cotree(pni, plot_cotree, print_cotree)'); 
%  pni is the marked petri net structure
%  if plot_cotree=1, then cotree will be plotted.'); 
%  if print_cotree=1, then ASCII cotree will be printed.'); 
%   e.g. "cotree(pni, 1, 1)" will both plot and print'); 
%
% Uses:	print_cotree, plot_cotree
%       
% Used by:	[main simulation file]
% NOTE:	  plot_cotree is based on the work by Univ. Cagliari
% Out parameters:	[]
%
% Example:	
%   % in main simulation file
%   pns = pnstruct('cotree_example_def');
%   dyn.m0 = {'p1',2, 'p4', 1};  % initial markings
%   pni = initialdynamics(pns, dyn);
%   cotree(pni,1);   % only one argument: the graphical plot only
%   cotree(pni,1,1); % two arguments: graphical plot and/or ASCII display

%   Reggie.Davidrajuh@uis.no (c) Version 6.0 (c) July 2012 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global PN;
PN = pni;
X0 = pni.X;

if eq(nargin, 1), % 
    disp(' '); disp('  cotree takes three input arguments (parameters)'); 
    disp('        cotree(pni, plot_cotree, print_cotree)'); 
    disp('  if plot_cotree=1, then cotree will be plotted.'); 
    disp('  if print_cotree=1, then ASCII cotree will be printed.'); 
    disp('  e.g. "cotree(pni, 1, 1)" will both plot and print'); disp(' '); 
    return
end;

if ge(nargin, 2), % now plot the cotree with the function plot_cotree
    if plot_ct, plot_cotree(X0); end;
end;

if eq(nargin, 3), % now print ASCII cotree 
    [COTREE] = build_cotree(X0); 
    if print_ct, print_cotree(COTREE); end;
end;
