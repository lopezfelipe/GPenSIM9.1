function [arcx] = extract_arc(arcElement)

arcx = [];

eval(['arcx.', arcElement.Attributes(1).Name, '=', 'arcElement.Attributes(1).Value', ';']);
eval(['arcx.', arcElement.Attributes(2).Name, '=', 'arcElement.Attributes(2).Value', ';']);
eval(['arcx.', arcElement.Attributes(3).Name, '=', 'arcElement.Attributes(3).Value', ';']);

arcStruct = arcElement.Children; 

lenArcStruct = length(arcStruct);
for j = 1:lenArcStruct,
    if strcmp(arcStruct(j).Name, 'inscription'),
        arcData = arcStruct(j).Children;
        lenArcData = length(arcData);
        for k = 1:lenArcData,
            if strcmp(arcData(k).Name, 'value'),
                arc_weight = arcData(k).Children.Data;
            end;
        end;                             
    end; % if strcmp(placeStruct(j).Name, 'name')            
end;
eval(['arcx.weight =', int2str(arc_weight), ';']);


