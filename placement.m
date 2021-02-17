%{
    PLACEMENT

    Posiziona i tetramini sull'immagine dello schema.
    Assumiamo che le immagini di input abbiano le stesse dimensioni.

    input:

        - immagine dei tetramini (scene)
        - immagine dello schema (scheme)
        - maschera del tetramino in questione (scene_mask)
        - maschera dello schema del tetramino (scheme_mask)
    
    algoritmo:

        1. calcoliamo le aree degli oggetti delle maschere (a_scene, a_scheme)

        2. troviamo il rapporto tra a_scene e a_scheme (scale)
           ridimensioniamo scene e scene_mask

        3. calcoliamo gli angoli di rotazione del tetramino e del tetramino flippato
           ruotiamo il tetramino e la scena (anche quelli flippati)

        4. troviamo quale delle maschere di scena ruotatate fitta meglio
           ruotiamo scene e scene_mask

        5. calcoliamo la distanza c_scene - c_scheme (d)
           trasliamo scene e scene_mask

        6. copiamo e incolliamo il tetramino sull'immagine
%}

function out = placement(scene,scheme,scene_mask,scheme_mask)

% calcoliamo le aree degli oggetti delle maschere
a_scene = sum(scene_mask, 'all');
a_scheme = sum(scheme_mask, 'all');

% ridimensionamento
scale = a_scheme/a_scene;
scene = imresize(scene,sqrt(scale));
scene_mask = imresize(scene_mask,sqrt(scale));

% controlli ridemensioni e crop
if scale < 1 % controllo su scena più piccola dello schema 
    
    tmp_scene = zeros(size(scheme));
    tmp_scene_mask = zeros(size(scheme_mask));

    tmp_scene(1:size(scene,1),1:size(scene,2),1:size(scene,3)) = scene;
    tmp_scene_mask(1:size(scene_mask,1),1:size(scene_mask,2)) = scene_mask;
    
    scene = tmp_scene;
    scene_mask = logical(tmp_scene_mask);
    
    % spostare tetramino al centro
    
elseif scale > 1   
    [scene,scene_mask] = centroid_crop(scene,scene_mask,size(scheme_mask));
end

% ROTAZIONE

% scena flippata
scene_flipped = fliplr(scene);
scene_mask_flipped = fliplr(scene_mask);

% proprietà
scene_angle = bwferet(scene_mask, "MaxFeretProperties").MaxAngle;
scheme_angle = bwferet(scheme_mask, "MaxFeretProperties").MaxAngle;

% angolo (opposto di scene_angle)
scene_flipped_angle = bwferet(scene_mask_flipped, "MaxFeretProperties").MaxAngle; 

% rotazioni minime
scene = imrotate(scene, -(scheme_angle - scene_angle),'crop');
scene_mask = imrotate(scene_mask, -(scheme_angle - scene_angle),'crop');

scene_flipped = imrotate(scene_flipped, -(scheme_angle - scene_flipped_angle),'crop');
scene_mask_flipped = imrotate(scene_mask_flipped, -(scheme_angle - scene_flipped_angle),'crop');

% vettori delle rotazioni
rotations = zeros(4,1);
rotations_flipped = zeros(4,1);

% centroide schema
c_scheme = int32(compute_centroid(scheme_mask));

for i = 0:3
    
    tmp = imrotate(scene_mask,90*i,'crop');
    c_tmp = int32(compute_centroid(tmp));
    d = c_scheme - c_tmp;
    tmp = imtranslate(tmp,d);

    rotations(i+1) = sum(sum(scheme_mask | not(tmp)));
    
    % flipped
    tmp_flipped = imrotate(scene_mask_flipped,90*i,'crop');
    c_tmp_flipped = int32(compute_centroid(tmp_flipped));
    d_f = c_scheme - c_tmp_flipped;
    tmp_flipped = imtranslate(tmp_flipped,d_f);

    rotations_flipped(i+1) = sum(sum(scheme_mask | not(tmp_flipped)));

end

i = find(rotations == max(rotations))-1;
i_flipped = find(rotations_flipped == max(rotations_flipped))-1;

if max(rotations) > max(rotations_flipped)
    scene_mask = imrotate(scene_mask,90*i,'crop');
    scene = imrotate(scene,90*i,'crop');
else
    scene_mask = imrotate(scene_mask_flipped,90*i_flipped,'crop');
    scene = imrotate(scene_flipped,90*i_flipped,'crop');
end

% traslazione
c_scene = int32(compute_centroid(scene_mask));

d = c_scheme - c_scene;
scene_mask = imtranslate(scene_mask,d);
scene = imtranslate(scene,d);

% copia e incolla
red = scene(:,:,1) .* scene_mask; 
green = scene(:,:,2) .* scene_mask;
blue = scene(:,:,3) .* scene_mask;

tetromino = cat(3,red,green,blue); % singolo tetramino

scene_mask_neg = not(scene_mask); % maschera singolo tetramino - negativo

red = scheme(:,:,1) .* scene_mask_neg + tetromino(:,:,1);
green = scheme(:,:,2) .* scene_mask_neg + tetromino(:,:,2);
blue = scheme(:,:,3) .* scene_mask_neg + tetromino(:,:,3);

out = cat(3,red,green,blue);

end

%{
    VISUALIZZARE LE IMMAGINI CON I CENTROIDI

    imshow(img);
    hold(imgca,'on');
    plot(centroid(:,1), centroid(:,2), 'r*');

    
    
    VISUALIZZARE LE IMMAGINI CON GLI ASSI
    
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
