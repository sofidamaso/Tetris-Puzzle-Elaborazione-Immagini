clear all;
close all;

%leggo le immagini di train segmento e faccio morfologia matematica e label
tr1 = rgb2ycbcr(imread('R01.jpg'));
tr2 = rgb2ycbcr(imread('R02.jpg'));

seg1 = threshYCbCrMean(tr1);
seg2 = threshYCbCrMean(tr2);

seg1 = (seg1-1).*-1;
seg2 = (seg2-1).*-1;

seg1od = imdilate(imopen(seg1,strel('diamond',11)),strel('disk',25));
seg2od = imdilate(imopen(seg2,strel('diamond',11)),strel('disk',25));

lab1 = bwlabel(seg1od);


lab2 = bwlabel(seg2od);
mkdir 'label_hu';

%scorro le label della prima immagine
for i= 1 : max(max(lab1))
    mask = lab1 == i;
    %calcolo momenti di Hu
    m = Hu_Moments(SI_Moment(mask,mask));
   
    position = [500 2500];
    %inserisco label e salvo immagine
    im = insertText(mask.*255,position,num2str(m),'FontSize', 70,'TextColor','white');
    imwrite(im,strcat('label_hu/seg1mask',num2str(i),'.jpg'));
    
end

%stessa cosa solo per la seconda immagine
for i= 1 : max(max(lab2))
    mask = lab2 == i;
    m = Hu_Moments(SI_Moment(mask,mask));

    position = [500 2500];
    im = insertText(mask.*255,position,num2str(m),'FontSize', 70,'TextColor','white');
    imwrite(im,strcat('label_hu/seg2mask',num2str(i),'.jpg'));
    
end