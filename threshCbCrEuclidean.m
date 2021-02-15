%{
    THRESHCBCREUCLIDEAN

    Funzione di sogliatura.
%}


function out_image = threshCbCrEuclidean(im,cb_mean,cr_mean,thresh)

% converto l'immagine in valori double e nei campi color ycbcr 
im = im2double(im);
im_ycbcr = rgb2ycbcr(im);
% calcolo distanza euclidea
cb = (im_ycbcr(:,:,2) -cb_mean).^2;
cr = (im_ycbcr(:,:,3) - cr_mean).^2;

x = (cb+cr).^0.5;

% thresholding
out_image = x >= thresh;

end
