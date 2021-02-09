%Prima fase di elaborazione: segmentazione delle immagini date
im1=imread('R01.jpg');
im2=imread('R02.jpg');
hsv1=rgb2hsv(im1);
hsv2=rgb2hsv(im2);
V1=hsv1(:,:,3);
V2=hsv2(:,:,3);

mask1=sauvola(V1, [85 85]);
mask1=medfilt2(mask1,[21 21]);
shadow1=im2double(im1).*(1-mask1);
im1shadow=im2double(im1)-shadow1;
pieces1=1-medfilt2(threshYCbCrMean(rgb2ycbcr(im1)),[27 27]);
out_im1=im1shadow.*pieces1;

mask2=sauvola(V2, [127 127]);
mask2=medfilt2(mask2,[21 21]);
shadow2=im2double(im2).*(1-mask2);
im2shadow=im2double(im2)-shadow2;
pieces2=1-medfilt2(threshYCbCrMean(rgb2ycbcr(im2)),[51 51]);
out_im2=im2shadow.*pieces2;

figure,subplot(1,2,1),imshow(out_im1),subplot(1,2,2),imshow(out_im2);
