function [PN] = create_new_incidence_matrix(PN, Dc, lenConstr)
%        [PN] = create_new_incidence_matrix(PN, Dc, lenConstr)

Ps = PN.No_of_places;
Ts = PN.No_of_transitions;

Cin = []; Cout = [];
for i = 1:lenConstr,
    zero_vector = zeros(1, Ts);
    d = Dc(i, :);
    dpos_index = find(d > 0); dneg_index = find(d < 0);
    dp = zero_vector; dp(dpos_index) = d(dpos_index);
    dn = zero_vector; dn(dneg_index) = abs(d(dneg_index));    
    Cin = [Cin dn'];  Cout = [Cout dp'];
end;

Ain =  PN.incidence_matrix(:, 1:Ps);
Aout = PN.incidence_matrix(:, Ps+1:end);
Acontrolled_in = [Ain Cin];
Acontrolled_out = [Aout Cout];
PN.incidence_matrix = [Acontrolled_in Acontrolled_out];