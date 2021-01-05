function out_image = threshYCbCrMeanVariable(im,cb_mean,cr_mean,pc)
      
     
      
      %sogliatura di cb e cr con una tolleranza del 2%
      cb_bw = (im(:,:,2) <= cb_mean+255*pc) .* (im(:,:,2) >= cb_mean-255*pc);
      
      cr_bw = (im(:,:,3) <= cr_mean+255*pc) .* (im(:,:,3) >= cr_mean-255*pc);
      
      out_image = cr_bw .* cb_bw;

end