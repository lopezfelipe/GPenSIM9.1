function [] = plot_continuos_variable(sim_results, set_of_plots, y_label)

global global_info
global PN

% Verify that set_of_plots is right
if ( mod(length(set_of_plots),2) == 0 ),
    no_of_vars = length(set_of_plots)/2;
else
    error('Cell of continuous variables must be even');
end;

set_of_places = {};
set_of_variables = {};

% Set of places
for i = 1:no_of_vars
    set_of_places{i} = set_of_plots{1+2*(i-1)};
    set_of_variables{i} = set_of_plots{2*i};
end;

vars_to_plot = {};

for i=1:length(set_of_places)
    for j=1:length(set_of_variables{i})
        vars_to_plot = ...
            [vars_to_plot; strcat(set_of_places{i},num2str(set_of_variables{i}{j}))];
    end;
end;

names_var = fieldnames(sim_results.LOG_CONT);

% Check if variables requested exist
for i=1:length(vars_to_plot)
    if ~any(strcmp(names_var,vars_to_plot{i})),
        error('Unknown continuous variable');
        return;
    end;
end;

xunits = 'Time'; % initially
if isfield(PN, 'HH_MM_SS'),
    if (PN.HH_MM_SS), xunits = [xunits, ' in HOURS']; end;
end;

k = 1;
for i = 1:length(vars_to_plot)
    names_tok = fieldnames(sim_results.LOG_CONT.(vars_to_plot{i}));
    for j = 1:length(names_tok)
        cont_data = sim_results.LOG_CONT.(vars_to_plot{i}).(names_tok{j});
        % First column is time, second column is state
        labels{k} = names_tok{j,1}; k = k+1;
        if isfield(PN, 'HH_MM_SS'),
            if (PN.HH_MM_SS),
                times = cont_data(:,1)/(60*60);
            else
                times = cont_data(:,1);
            end;
        else
            times = cont_data(:,1);
        end;        
        plot(times, cont_data(:,2),'h','LineWidth',2.0); grid on; hold on;
    end;
end;

legend(labels); ylabel(y_label); xlabel(xunits);

end