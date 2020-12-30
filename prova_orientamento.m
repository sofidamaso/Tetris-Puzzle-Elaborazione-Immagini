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

%immagini temporanea per disegnare asse
tmp = seg1od.*255;

%scorro le label dell'immagine 1
for i = 1 : max(max(lab1))
    mask = lab1 == i;
    
    
    M20 = Centr_Moment(mask,mask,2,0);
    M02 = Centr_Moment(mask,mask,0,2);
    M11 = Centr_Moment(mask,mask,1,1);
    M00 = Centr_Moment(mask,mask,0,0);
    
    
    %calcolo lunghezza di asse principale e secondario
    a = sqrt((2*(M20+M02+sqrt((M20-M02)^2+4*M11^2)))/M00);
    b = sqrt((2*(M20+M02-sqrt((M20-M02)^2+4*M11^2)))/M00);
    
    %cacolo rotazione asse principale
    o = 0.5*atan((2*M11)/(M20-M02));
    
    %cacolo centroid
    centroid_y = moment(mask,mask,1,0)/moment(mask,mask,0,0);
    centroid_x = moment(mask,mask,0,1)/moment(mask,mask,0,0);
    %disegno centroide
    tmp = insertShape(tmp,'circle',[centroid_x centroid_y 15], 'LineWidth',5,'Color','blue');
    
  
    %disegno asse
    x1=centroid_x-(a*sin(o));
    y1=centroid_y-(a*cos(o));
    x2=centroid_x+(a*sin(o));
    y2=centroid_y+(a*cos(o));
    tmp = insertShape(tmp,'line',[x1 y1 x2 y2], 'LineWidth',5,'Color','blue');
end

%salvo immagine
imshow(tmp);
imwrite(tmp,'orientamento1.jpg');
figure;
tmp =  seg2od.*255;

%faccio stessa cosa solo per la immagine 2
for i = 1 : max(max(lab2))
    mask = lab2 == i;
    
    
    M20 = Centr_Moment(mask,mask,2,0);
    M02 = Centr_Moment(mask,mask,0,2);
    M11 = Centr_Moment(mask,mask,1,1);
    M00 = Centr_Moment(mask,mask,0,0);
    
    a = sqrt((2*(M20+M02+sqrt((M20-M02)^2+4*M11^2)))/M00);
    b = sqrt((2*(M20+M02-sqrt((M20-M02)^2+4*M11^2)))/M00);
    
    o = 0.5*atan((2*M11)/(M20-M02));
    
    centroid_y = moment(mask,mask,1,0)/moment(mask,mask,0,0);
    centroid_x = moment(mask,mask,0,1)/moment(mask,mask,0,0);
    tmp = insertShape(tmp,'circle',[centroid_x centroid_y 15], 'LineWidth',5,'Color','blue');
    
  
    
    x1=centroid_x-(a*sin(o));
    y1=centroid_y-(a*cos(o));
    x2=centroid_x+(a*sin(o));
    y2=centroid_y+(a*cos(o));
    
 
    
    tmp = insertShape(tmp,'line',[x1 y1 x2 y2], 'LineWidth',5,'Color','blue');
    
end
imwrite(tmp,'orientamento2.jpg');
imshow(tmp);