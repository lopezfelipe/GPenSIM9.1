function [] = print_controller_info(X)
%        [] = print_controller_info(X)

global PN

Ps = PN.No_of_places;
Cs = PN.No_of_control_places;
Ts = PN.No_of_transitions;
A = PN.incidence_matrix;

disp(' ');
disp('======= Controller Composition ======= ');

disp(' '); 
for i = 1:Cs
    pcx = Ps-Cs+i;
    place_name = PN.global_places(pcx).name;
    disp(['Control place: ', place_name]);
    ain = A(:, pcx);
    str = '    ';
    for j = 1: Ts,
        if ain(j),
            trans_name = PN.global_transitions(j).name;
            str = [str, '(', place_name, ' -> ', trans_name, ' : ',...
                int2str(ain(j)), ')   '];
        end;
    end;
    disp(str);
    
    aout = A(:, Ps+pcx:end);
    str = '    ';
    for j = 1: Ts,
        if aout(j),
            trans_name = PN.global_transitions(j).name;
            str = [str, '', trans_name, ' -> ', place_name, ' : ',...
                int2str(aout(j)), ')   '];
        end;
    end;
    disp(str);     
end;

if any(X), 
    disp(' '); disp('Initial markings on the Control places : ');
    str = markings_string (X, [Ps-Cs+1 Ps]); 
    if not(isempty(str)), disp(str); 
    else disp('(no tokens in control variables)');
    end;
end;
disp(' ');
