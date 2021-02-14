%{
    ROTATION

    Ruota i tetramini.
    NB. MaxFeretProperties.MaxAngle ritorna i gradi nel range [–180°,180°]
%}

function mask_scene = rotation(mask_scene,mask_scheme)

% angoli
scene_props = bwferet(mask_scene,'MaxFeretProperties');
scheme_props = bwferet(mask_scheme,'MaxFeretProperties');

scene_angle = scene_props.MaxAngle;
scheme_angle = scheme_props.MaxAngle;

angle = scheme_angle - scene_angle; 

rotations = zeros(4,2);

c_scheme = int32(compute_centroid(mask_scheme));

for i = 0:3
    
    tmp = imrotate(mask_scene,-angle-(90*i),'crop');
    c_tmp = int32(compute_centroid(tmp));
    d = c_scheme - c_tmp;
    tmp = imtranslate(tmp,d);
        
    rotations(i+1,1) = sum(sum(mask_scheme+not(tmp)));
    rotations(i+1,2) = i;
end







%{
    Per visualizzare gli assi:
    
    maxLabel = max(mask(:));

    h = imshow(mask,[]);
    axis = h.Parent;
    for labelvalues = 1:maxLabel
        xmax = [props.MaxCoordinates{labelvalues}(1,1) props.MaxCoordinates{labelvalues}(2,1)];
        ymax = [props.MaxCoordinates{labelvalues}(1,2) props.MaxCoordinates{labelvalues}(2,2)];
        imdistline(axis,xmax,ymax);
    end
    title(axis,'Maximum Feret Diameter of Objects');
    colorbar('Ticks',1:maxLabel)  

%}

% maxLabel = max(mask_scene(:));
% 
% h = imshow(mask_scene,[]);
% axis = h.Parent;
% for labelvalues = 1:maxLabel
%     xmax = [scene_props.MaxCoordinates{labelvalues}(1,1) scene_props.MaxCoordinates{labelvalues}(2,1)];
%     ymax = [scene_props.MaxCoordinates{labelvalues}(1,2) scene_props.MaxCoordinates{labelvalues}(2,2)];
%     imdistline(axis,xmax,ymax);
% end
% title(axis,'Maximum Feret Diameter of Objects - scene');
% colorbar('Ticks',1:maxLabel)  
% 
% 
% 
% 
% maxLabel = max(mask_scheme(:));
% 
% h = imshow(mask_scheme,[]);
% axis = h.Parent;
% for labelvalues = 1:maxLabel
%     xmax = [scheme_props.MaxCoordinates{labelvalues}(1,1) scheme_props.MaxCoordinates{labelvalues}(2,1)];
%     ymax = [scheme_props.MaxCoordinates{labelvalues}(1,2) scheme_props.MaxCoordinates{labelvalues}(2,2)];
%     imdistline(axis,xmax,ymax);
% end
% title(axis,'Maximum Feret Diameter of Objects - scheme');
% colorbar('Ticks',1:maxLabel)