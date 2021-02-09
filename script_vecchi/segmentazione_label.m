clear all;
close all;
%leggo immagini di train e converto ycbcr
tr1RGB = imread('R01.jpg');
tr1HSV = rgb2hsv(tr1RGB);
tr1 = rgb2ycbcr(tr1RGB);
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

usingLab = lab2;
usingTr = tr2;
tmp = zeros(size(seg1,1),size(seg1,2));
a=0;
masktmp = 0;
for i = 1 : max(max(usingLab))
    
    mask = usingLab == i;
    
    ycbcrMask = usingTr.*uint8(mask);
    avFilt = fspecial('average',[25,25]);
    ycbcrMask = imfilter(ycbcrMask,avFilt);
%     close all;
     %imshow(ycbcrMask);
%     figure;
    histcb = imhist(nonzeros(ycbcrMask(:,:,2)));
    histcr = imhist(nonzeros(ycbcrMask(:,:,3)));
%     subplot(1,2,1),plot(histcb),subplot(1,2,2),plot(histcr);
    hsvMask = tr1HSV.*double(mask);
    
    cbMean = mean(nonzeros(ycbcrMask(:,:,2)),'all');
    crMean = mean(nonzeros(ycbcrMask(:,:,3)),'all');
    
    
    hsvMask = imfilter(hsvMask,avFilt);
    centroid_x = round(moment(mask,mask,1,0)/moment(mask,mask,0,0));
    centroid_y = round(moment(mask,mask,0,1)/moment(mask,mask,0,0));
     cbCentroid = ycbcrMask(round(centroid_x),round(centroid_y),2);
     crCentroid = ycbcrMask(round(centroid_x),round(centroid_y),3);
%     cbCentroid = mean(ycbcrMask(max(1,centroid_x-25):min(size(ycbcrMask,1),centroid_x+25),max(1,centroid_y-25):min(size(ycbcrMask,2),centroid_y+25),2),'all');
%     crCentroid = mean(ycbcrMask(max(1,centroid_x-25):min(size(ycbcrMask,1),centroid_x+25),max(1,centroid_y-25):min(size(ycbcrMask,2),centroid_y+25),3),'all');
%     %v = hsvMask(centroid_x,centroid_y,3);
    %v = mean(hsvMask(max(1,centroid_x-25):min(size(hsvMask,1),centroid_x+25,3),max(1,centroid_y-25):min(size(hsvMask,2),centroid_y+25,3)),'all');
    cbHistMax = find(histcb == max(histcb),1);
    crHistMax = find(histcr == max(histcr),1);
    
    centroidDiff = abs(cbMean-cbCentroid) + abs(crMean-crCentroid);
    histDiff = abs(cbMean-cbHistMax) + abs(crMean-crHistMax);
    
    if centroidDiff < histDiff
        cbMean = cbCentroid;
        crMean = crCentroid;
    else
        cbMean = cbHistMax;
        crMean = crHistMax;
    end
    
    %mask2 = threshVVariable(hsvMask,v);
    mask2 = threshYCbCrMeanVariable(ycbcrMask,cbMean,crMean,0.02);
    mask2 = imfill(mask2,'holes');
    
   
    
    ycbcrMask2 = usingTr.*uint8(mask2);
    stdCb = std2(nonzeros(ycbcrMask2(:,:,2)));
    stdCr = std2(nonzeros(ycbcrMask2(:,:,3)));
    stdbY = std2(nonzeros(ycbcrMask2(:,:,1)));

   if (stdbY) > 25
        histcb = imhist(nonzeros(ycbcrMask2(:,:,2)));
        histcr = imhist(nonzeros(ycbcrMask2(:,:,3)));
        cbHistMax = find(histcb == max(histcb),1);
        crHistMax = find(histcr == max(histcr),1);
        mask2 = threshYCbCrMeanVariable(ycbcrMask2,cbHistMax,crHistMax,0.02);
        ycbcrMask2 = usingTr.*uint8(mask2);
        histY = imhist(nonzeros(ycbcrMask2(:,:,1)));
       
        yHistMax = find(histY == max(histY),1);
        mask2 = threshVVariable(ycbcrMask2,yHistMax,0.02);
       
   end
   tmp = tmp + mask2;
    
end
 tmp = imclose(tmp,strel('disk',55));
subplot(1,2,1),imshow(usingTr),subplot(1,2,2),imshow(usingTr.*uint8(tmp));






