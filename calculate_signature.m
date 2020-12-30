clear all;
close all;
%leggo immagini di train e converto ycbcr
tr1 = rgb2ycbcr(imread('R01.jpg'));
tr2 = rgb2ycbcr(imread('R02.jpg'));

%segmento per media db e dr
seg1 = threshYCbCrMean(tr1);
seg2 = threshYCbCrMean(tr2);

seg1 = (seg1-1).*-1;
seg2 = (seg2-1).*-1;

%faccio prima opening poi dilate
seg1od = imdilate(imopen(seg1,strel('diamond',11)),strel('disk',25));
seg2od = imdilate(imopen(seg2,strel('diamond',11)),strel('disk',25));

%labeling
lab1 = bwlabel(seg1od);
lab2 = bwlabel(seg2od);

%immagine temporanea per disegnarci sopra
tmp = seg1od.*255;

%scorro per ogni label nell'immagine 1
for i = 1 : max(max(lab1))
    %prendo l'oggetto corrispondente alla label
    mask = lab1 == i;
    im = zeros(size(mask));
   
    %calcolo il centroide con i momenti
    centroid_x = moment(mask,mask,1,0)/moment(mask,mask,0,0);
    centroid_y = moment(mask,mask,0,1)/moment(mask,mask,0,0);
   
    %trovo bordo 8connesso (no bordi di buchi interni)
    bw = bwboundaries(mask,8,'noholes');
    
    %prendo il primo bordo (in teoria unico)
    b = bw{1};
    figure
    imshow(mask);
    hold on
    x = b(:,1);
    y = b(:,2);
    %calcolo distanze da centroide
    distances = sqrt((x - centroid_x).^2 + (y - centroid_y).^2);
    
    %disegno bordo
    plot(b(:,2),b(:,1),'g','LineWidth',3);
    
    %disegno centroide
    hold on
    plot(centroid_y,centroid_x,'x','MarkerSize',10)
    
    %trovo il massimo e "scorro" il grafico per mettere come primo il max
    max_value = find(distances == max(max(distances)));
    if(max_value(1) ~= 1)
        norm_distances = cat(1,distances(max_value(1):end),distances(1:max_value(1)-1));
    else
        norm_distances = distances;
    end
    
    %disegno il max
    hold on 
    plot(b(max_value,2),b(max_value,1),'s','MarkerSize',5,'MarkerFaceColor','b');
    
    %salvo le immagini del grafico e del bordo
    saveas(gcf,strcat('signatures/seg1_',num2str(i),'_image','.jpg'));
    close all;
    plot(norm_distances);
    saveas(gcf,strcat('signatures/seg1_',num2str(i),'_sig','.jpg'));
    close all;
end

%identico a sopra solo per l'immagine 2

for i = 1 : max(max(lab2))
    mask = lab2 == i;
    im = zeros(size(mask));
   
    centroid_x = moment(mask,mask,1,0)/moment(mask,mask,0,0);
    centroid_y = moment(mask,mask,0,1)/moment(mask,mask,0,0);
   
    bw = bwboundaries(mask,8,'noholes');
    
    b = bw{1};
    figure
    imshow(mask);
    hold on

    x = b(:,1);
    y = b(:,2);
    distances = sqrt((x - centroid_x).^2 + (y - centroid_y).^2);
    plot(b(:,2),b(:,1),'g','LineWidth',3);
    hold on
    plot(centroid_y,centroid_x,'x','MarkerSize',10)
    max_value = find(distances == max(max(distances)));
    if(max_value(1) ~= 1)
        norm_distances = cat(1,distances(max_value(1):end),distances(1:max_value(1)-1));
    else
        norm_distances = distances;
    end
    hold on 
    plot(b(max_value,2),b(max_value,1),'s','MarkerSize',5,'MarkerFaceColor','b');

    saveas(gcf,strcat('signatures/seg2_',num2str(i),'_image','.jpg'));
    close all;
   
    plot(norm_distances);
    saveas(gcf,strcat('signatures/seg2_',num2str(i),'_sig','.jpg'));
    close all;
end