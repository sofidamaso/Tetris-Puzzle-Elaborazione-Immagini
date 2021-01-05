% Prende in input un'immagine in formato ycbcr con valori da 0 a 255

function out_image = threshYCbCrMean(im)
      % medie cb calcolata da un crop di un'immagine di training con solo sfondo
      cb_mean = 107.888; 
      cr_mean = 144.546;
      pcb = 0.05;
      pcr = 0.02;
      %sogliatura di cb e cr con una tolleranza del 2%
      cb_bw = (im(:,:,2) <= cb_mean+255*pcb) .* (im(:,:,2) >= cb_mean-255*pcb);
      
      cr_bw = (im(:,:,3) <= cr_mean+255*pcr) .* (im(:,:,3) >= cr_mean-255*pcr);
      
      out_image = cr_bw .* cb_bw;

end