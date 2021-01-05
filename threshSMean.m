function out_image = threshSMean(im)
      % medie cb calcolata da un crop di un'immagine di training con solo sfondo
      s_mean = 0.3795;
      pc = 0.2;
      
      %sogliatura di cb e cr con una tolleranza del 2%
      s_bw = (im(:,:,2) <= s_mean+pc) .* (im(:,:,2) >= s_mean-pc);
      
      
      out_image = s_bw;

end