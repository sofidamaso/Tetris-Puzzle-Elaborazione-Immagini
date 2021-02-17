%{
    SCENE_SEGMENTATION
    Segmenta la scena tramite classificazione.
    
    Input: immagine di scena
    Output: maschera binaria
%}

function mask = scene_segmentation(img)
    
% valori calcolati dalle immagini di training per il background
% h_mean = 0.08825;
% cb_mean = 0.425; 
% cr_mean = 0.5674;

% mask = threshHCbCrEuclidean(img,h_mean,cb_mean,cr_mean,0.035);
% mask = threshCbCrEuclidean(img,cb_mean,cr_mean,0.035);

R_ycbcr = rgb2ycbcr(im2double(img));

sfondo = im2double(imread('training/sfondo.png'));
sfondo_ycbcr = rgb2ycbcr(sfondo);

[r,c,ch] = size(sfondo_ycbcr);

% sfondo_ycbcr è un array con i pixel messi per riga, e tre colonne dei canali
sfondo_ycbcr = reshape(sfondo_ycbcr,r*c,ch);

% media e deviazione standard dell'immagine sfondo_ycbcr
m = mean(sfondo_ycbcr);
v = std(sfondo_ycbcr);

k = 6.5;

[r,c,ch] = size(R_ycbcr);
image = reshape(R_ycbcr,r*c,ch);

maskcb = image(:,2) >= m(2)-k*v(2) & image(:,2) <= m(2)+k*v(2);
maskcr = image(:,3) >= m(3)-k*v(3) & image(:,3) <= m(3)+k*v(3);

mask = maskcb & maskcr;

mask = (reshape(mask,r,c,1));
mask = (mask-1).*-1;

% serve a "chiudere" le forme che rimangono aperte (es i rettangoli
% bianchi in alcunu casi)
mask = imclose(mask,strel('disk',3));

% riempie i buchi generati
mask = imfill(mask,'holes');

% erode "aggressiva" che permette di pulire le forme da eventuale
% bordo rimasto attaccato
mask = imerode(mask,strel('disk',17));

% applico sauovola per eliminare le ombre (le ombre meno scure non
% vengono eliminate)
hsvim = rgb2hsv(uint8(mask).*img);
shadow_seg = shadow_mask(hsvim(:,:,3));
mask = mask.*shadow_seg;

%serve per riempire i buchi creati da sauvola nei pezzi neri
mask = imfill(mask,'holes');

mask = imopen(mask,strel('disk',15));

size_thresh = floor((size(mask,1)*size(mask,2))*0.005);

mask = bwareaopen(mask,size_thresh);
end
