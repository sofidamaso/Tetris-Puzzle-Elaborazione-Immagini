%{
    CENTROID_CROP

    Funzione per croppare l'immagine di scena e la sua maschera 
    ridimensionate più grandi dell'immagine di schema.

    Trasla l'oggetto della scena in modo che il centroide sia al centro
    dell'immagine; l'immagine viene croppata in modo da mantenere il
    centroide al centro.

    dim è la dimensione di output desiderata
%}

function [scene,scene_mask] = centroid_crop(scene,scene_mask,dim)

c_scene = int32(compute_centroid(scene_mask));

center = int32(ceil(size(scene_mask)/2));
center = [center(2),center(1)];
d = center - c_scene;
scene_mask = imtranslate(scene_mask,d);
scene = imtranslate(scene,d);

dx = floor(dim(2)/2);
dy = floor(dim(1)/2);

c_min = center(1) - dx;
c_max = center(1) + dx;
r_min = center(2) - dy;
r_max = center(2) + dy;

scene = scene(r_min:r_max-1, c_min:c_max-1, 1:3);
scene_mask = scene_mask(r_min:r_max-1, c_min:c_max-1);

end

%{
    PER VISUALIZZARE I PUNTI x E y SULL'IMMAGINE
  
    imshow(img)
    hold on;
    plot(x, y, 'r+', 'MarkerSize', 15, 'LineWidth', 1);  
%}
