% Prende in input un'immagine in formato ycbcr con valori da 0 a 255

function out_image = threshYCbCrMean(im)
      % medie cb calcolata da un crop di un'immagine di training con solo sfondo
      cb_mean = 107; 
      cr_mean = 144;
      
      %sogliatura di cb e cr con una tolleranza del 2%
      cb_bw = (im(:,:,2) <= cb_mean+255*0.02) .* (im(:,:,2) >= cb_mean-255*0.02);
      
      cr_bw = (im(:,:,3) <= cr_mean+255*0.02) .* (im(:,:,3) >= cr_mean-255*0.02);
      
      out_image = cr_bw .* cb_bw;

end