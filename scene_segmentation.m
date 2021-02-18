%{
    SCENE_SEGMENTATION
    Segmenta la scena tramite classificazione.
    
    Input: immagine di scena
    Output: maschera binaria
%}

function mask = scene_segmentation(scene)

scene_ycbcr = rgb2ycbcr(im2double(scene));

sfondo = im2double(imread('training/sfondo.png'));
sfondo_ycbcr = rgb2ycbcr(sfondo);

[r,c,ch] = size(sfondo_ycbcr);

% sfondo_ycbcr è un array con i pixel messi per riga, e tre colonne dei canali
sfondo_ycbcr = reshape(sfondo_ycbcr,r*c,ch);

% media e deviazione standard dell'immagine sfondo_ycbcr
m = mean(sfondo_ycbcr);
v = std(sfondo_ycbcr);

k = 6.5;

[r,c,ch] = size(scene_ycbcr);
image = reshape(scene_ycbcr,r*c,ch);

maskcb = image(:,2) >= m(2)-k*v(2) & image(:,2) <= m(2)+k*v(2);
maskcr = image(:,3) >= m(3)-k*v(3) & image(:,3) <= m(3)+k*v(3);

mask = maskcb & maskcr;

mask = (reshape(mask,r,c,1));
mask = not(mask);

% chiude le forme che rimangono aperte (es i rettangoli
% bianchi in alcuni casi)
mask = imclose(mask,strel('disk',3));

% riempie i buchi generati
mask = imfill(mask,'holes');

% erode "aggressiva" che permette di pulire le forme da eventuale
% bordo in eccesso
mask = imerode(mask,strel('disk',17));

% applico sauovola sul canale V per eliminare le ombre (le ombre meno scure non
% vengono eliminate)
scene_hsv = rgb2hsv(scene);
scene_v = scene_hsv(:,:,3);

shadows = shadow_mask(scene_v);

mask = mask & shadows;

% serve per riempire i buchi creati da sauvola nei pezzi neri
mask = imfill(mask,'holes');

mask = imopen(mask,strel('disk',15));

size_thresh = floor((size(mask,1)*size(mask,2))*0.005);

mask = bwareaopen(mask,size_thresh);

end
