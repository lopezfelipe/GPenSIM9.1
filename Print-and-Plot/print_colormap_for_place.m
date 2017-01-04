function [] = print_colormap_for_place(PN, place)
% [] = print_colormap_for_place(PN, place)

%  Reggie.Davidrajuh@uis.no (c) Version 6.0 (c) 10 july 2012  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pi = place; 
if ischar(pi), pi = check_valid_place(place); end;

disp(' '); disp(' ');
disp(['Color Map for place: ', place]);
disp(' ');

% extract color_map for given place
% disp(['extract color_map for given place....']);
color_map = PN.color_map;
new_CM = [];
for i=1:length(color_map),
    cm = color_map(i);
    if isequal(pi, color_map(i).place),
        new_CM = [new_CM cm];
    end;
end;

% print the extracted color_map
for i = 1:length(new_CM),
     if not(isnan(new_CM(i).time)),
        colors = new_CM(i).color;
        [m, n] = size(colors);
        colorset = ' '; for k = 1:m, colorset = [colorset, ' ', colors{k}]; end;
        disp_str = ['Time: ',num2str(new_CM(i).time), ' Color: ',...
            colorset];
        disp(disp_str);
     end;
end;    
