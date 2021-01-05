function out_image = threshVVariable(im,v,pc)
      
      
      %sogliatura di cb e cr con una tolleranza del 2%
      
      
      v_bw = (im(:,:,1) <= v+pc*255) .* (im(:,:,1) >= v-pc*255);
      
      out_image = v_bw;

end