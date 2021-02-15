%input: immagine RGB
%output: immagine binaria
function out_image = scene_segmentation(im)
    
      
      
      %valori calcolati dalle immagini di training per il background
      h_mean = 0.08825;
      cb_mean = 0.425; 
      cr_mean = 0.5674;
 
      out_image = threshHCbCrEuclidean(im,h_mean,cb_mean,cr_mean,0.035);
    

     
      
       %serve a "chiudere" le forme che rimangono aperte (es i rettangoli
       %bianchi in alcunu casi)
       out_image = imclose(out_image,strel('disk',3));
       %riempie i buchi generati
       out_image = imfill(out_image,'holes');
       %erode "aggressiva" che permette di pulire le forme da eventuale
       %bordo rimasto attaccato
       out_image = imerode(out_image,strel('disk',15));
       %applico sauovola per eliminare le ombre (le ombre meno scure non
       %vengono eliminate)
       hsvim = rgb2hsv(uint8(out_image).*im);
       shadow_seg = shadow_mask(hsvim(:,:,3));
       out_image = out_image.*shadow_seg;
       
       %serve per riempire i buchi creati da sauvola nei pezzi neri
       out_image = imfill(out_image,'holes');
       
       out_image = imopen(out_image,strel('disk',15));
end