%{
    PLACEMENT

    Assumiamo che le immagini di input abbiano le stesse dimensioni.

    input:

        - immagine dei tetramini (scene)
        - immagine dello schema (scheme)
        - maschera del tetramino in questione (mask_scene)
        - maschera dello schema del tetramino (mask_scheme)
    
    algoritmo:

        1. calcoliamo le aree degli oggetti delle maschere (a_scene, a_scheme)

        2. Troviamo il rapporto tra a_scene e a_scheme (scale)
           ridimensioniamo scene e mask_scene

        3. calcoliamo i centroidi degli oggetti delle maschere (c_scene, c_scheme)

        4. calcoliamo la distanza c_scene - c_scheme (d)
           trasliamo mask_scene
           trasliamo scene

        5. rotazione
        
        6. croppiamo scene e mask_scene

        7. copiamo e incolliamo il tetramino sull'immagine
%}

function out = placement(scene,scheme,mask_scene,mask_scheme)

% calcoliamo le aree degli oggetti delle maschere
a_scene = sum(mask_scene, 'all');
a_scheme = sum(mask_scheme, 'all');

% ridimensionamento
scale = a_scheme/a_scene;

scene = imresize(scene,sqrt(scale));
mask_scene = imresize(mask_scene,sqrt(scale));

if scale < 1 % controllo su scena più piccola dello schema 
    
    tmp_scene = zeros(size(scheme));
    tmp_mask_scene = zeros(size(mask_scheme));

    tmp_scene(1:size(scene,1),1:size(scene,2),1:size(scene,3)) = scene;
    tmp_mask_scene(1:size(mask_scene,1),1:size(mask_scene,2)) = mask_scene;
    
    scene = tmp_scene;
    mask_scene = logical(tmp_mask_scene);
    
    clear tmp_scene;
    clear tmp_mask_scene;

end

% rotazione

% 
% % calcoliamo i centroidi 
% c_scene = int32(compute_centroid(mask_scene));
% c_scheme = int32(compute_centroid(mask_scheme));
% 
% % traslazione affinché c_scene == c_scheme
% d = c_scheme - c_scene;
% mask_scene = imtranslate(mask_scene,d);
% scene = imtranslate(scene,d);

% crop
if scale > 1
    mask_scene = mask_scene(1:size(scheme,1), 1:size(scheme,2));
    scene = scene(1:size(scheme,1), 1:size(scheme,2), 1:3);
end

% copia e incolla
red = scene(:,:,1) .* mask_scene; 
green = scene(:,:,2) .* mask_scene;
blue = scene(:,:,3) .* mask_scene;

tetromino = cat(3,red,green,blue); % singolo tetramino

mask_scene_neg = not(mask_scene); % maschera singolo tetramino - negativo

red = scheme(:,:,1) .* mask_scene_neg + tetromino(:,:,1);
green = scheme(:,:,2) .* mask_scene_neg + tetromino(:,:,2);
blue = scheme(:,:,3) .* mask_scene_neg + tetromino(:,:,3);

out = cat(3,red,green,blue);

end

%{
    Per visualizzare le imamgini con i centroidi:

    imshow(img);
    hold(imgca,'on');
    plot(centroid(:,1), centroid(:,2), 'r*');
%}

% scene = im2double(imread('scene/P04.jpg'));
% scheme = im2double(imread('schemi/S03.jpg'));
% mask_scene = im2bw(im2gray(imread('maschere_gt/P04-gt.jpg')));
% mask_scheme = im2bw(im2gray(imread('maschere_gt/S03-gt.jpg')));

% scene = im2double(imread('scene/P11.jpg'));
% scheme = im2double(imread('schemi/S01.jpg'));
% mask_scene = im2bw(im2gray(imread('maschere_gt/P11-gt.jpg')));
% mask_scheme = im2bw(im2gray(imread('maschere_gt/S01-gt.jpg')));