%{
    SCENE_SEGMENTATION

    Segmenta la scena tramite la media dei canali H, Cb e Cr.
    
    Input: immagine di scena
    Output: maschera binaria
%}

function mask = scene_segmentation(img)
    
%valori calcolati dalle immagini di training per il background
h_mean = 0.08825;
cb_mean = 0.425; 
cr_mean = 0.5674;

mask = threshHCbCrEuclidean(img,h_mean,cb_mean,cr_mean,0.035);

%serve a "chiudere" le forme che rimangono aperte (es i rettangoli
%bianchi in alcunu casi)
mask = imclose(mask,strel('disk',3));

%riempie i buchi generati
mask = imfill(mask,'holes');

%erode "aggressiva" che permette di pulire le forme da eventuale
%bordo rimasto attaccato
mask = imerode(mask,strel('disk',15));

%applico sauovola per eliminare le ombre (le ombre meno scure non
%vengono eliminate)
hsvim = rgb2hsv(uint8(mask).*img);
shadow_seg = shadow_mask(hsvim(:,:,3));
mask = mask.*shadow_seg;

%serve per riempire i buchi creati da sauvola nei pezzi neri
mask = imfill(mask,'holes');

mask = imopen(mask,strel('disk',15));

size_thresh = floor((size(mask,1)*size(mask,2))*0.005);

mask = bwareaopen(mask,size_thresh);
end