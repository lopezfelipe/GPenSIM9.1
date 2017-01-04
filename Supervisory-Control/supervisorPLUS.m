function [PN, dynamicpart, synthesis_ok] = supervisorPLUS(PN, dynamicpart, ...
                constraints, uncontrollables, unobservables)
%        [PN, dynamicpart, synthesis_ok] = supervisorPLUS(PN, dynamicpart, ...
%               constraints, uncontrollables, unobservables)
%

synthesis_ok = true; % assume the controller synthesis will be successful
lenConstr = length(constraints);

% handle initial makrings
[L, B, m0] = get_L_B_m0(PN, dynamicpart, constraints);
PN.X = m0;  
[~,~,Dp] = gpensim_2_PNCT(PN); % incidence matrix of the process

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUPERVISOR Plus: some transitions are controllable and/or observable 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nuc = 0; uc_ts = []; % initial assumption on uncontrollables
nuo = 0; uo_ts = []; % initial assumption on unobservables 

if ge(nargin, 4),  % get the set of uncontrollable transitions
    [nuc, uc_ts] = get_transitions(PN, uncontrollables);
end;
if ge(nargin, 5),  % get the set of unobservable transitions
    [nuo, uo_ts] = get_transitions(PN, unobservables);
end;

if or(nuc, nuo), % there are uncontrollable/unobservable trans   
    [L1, B1, R1, R2, how, dhow] = SPNBOX_mro_adm(L, B, ...
                           Dp, uc_ts, uo_ts, m0');
else
    % simple supervisor, with all trans observable & controllable
    L1 = L; B1 = B; how = 'ok';
end;

if not(strcmp(how, 'ok')),
    disp('Controller not feasible ...');
    synthesis_ok = false; % error('Controller not feasible ...');
    return
end;

% controller
Dc = -1 * L1 * Dp;  
muC = B1  - L1 * m0'; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dynamicpart.initial_markings = [PN.X muC'];
PN.X = [PN.X muC'];

PN = create_new_incidence_matrix(PN, Dc, lenConstr);

% add slack variables to the list of global_places 
PN = add_slacks_to_global_places(PN, lenConstr);

