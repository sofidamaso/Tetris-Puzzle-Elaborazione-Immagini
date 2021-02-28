%{
    THRESHHCBCREUCLIDEAN

    Funzione di sogliatura.
%}


function out_image = threshHCbCrEuclidean(im,h_mean,cb_mean,cr_mean,thresh)

% converto l'immagine in valori double e nei campi color ycbcr e hsv
im = im2double(im);
im_ycbcr = rgb2ycbcr(im);
im_hsv = rgb2hsv(im);

% calcolo distanza euclidea
h = (im_hsv(:,:,1) - h_mean) .^2;
cb = (im_ycbcr(:,:,2) -cb_mean).^2;
cr = (im_ycbcr(:,:,3) - cr_mean).^2;

x = (h+cb+cr).^0.5;

% thresholding
out_image = x >= thresh;

end
