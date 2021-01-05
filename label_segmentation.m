%input: immagine RGB
%output: immagine binaria
function out_seg = label_segmentation(im)
    trYCbCr = rgb2ycbcr(im);

    %segmento per media cb e cr
    %problema quanta tolleranza lasciare in questa funzione
    seg = threshYCbCrMean(trYCbCr);

    seg = (seg-1).*-1;
    
    %qui è la segmentazione "vecchia"
    %faccio prima opening poi dilate
    segod = imdilate(imopen(seg,strel('diamond',11)),strel('disk',25));

    %labeling
    lab = bwlabel(segod);

    usingLab = lab;
    avFilt = fspecial('average',[25,25]);
        
    usingTr = imfilter(trYCbCr,avFilt);
    %immagine dove salvo le singole maschere
    tmp = zeros(size(seg,1),size(seg,2));
    
    %scorro le label
    for i = 1 : max(max(usingLab))
    
        mask = usingLab == i;

        
        ycbcrMask = usingTr.*uint8(mask);
        %calcolo istogramma cb e cr
        histcb = imhist(nonzeros(ycbcrMask(:,:,2)));
        histcr = imhist(nonzeros(ycbcrMask(:,:,3)));
    
        %calcolo media cb e cr
  

        cbMean = mean(nonzeros(ycbcrMask(:,:,2)),'all');
        crMean = mean(nonzeros(ycbcrMask(:,:,3)),'all');

        %calcolo centroide
        centroid_x = round(moment(mask,mask,1,0)/moment(mask,mask,0,0));
        centroid_y = round(moment(mask,mask,0,1)/moment(mask,mask,0,0));
        
        %prendo valore cb e cr nel centroide
        cbCentroid = ycbcrMask(round(centroid_x),round(centroid_y),2);
        crCentroid = ycbcrMask(round(centroid_x),round(centroid_y),3);
        
        %trovo valori cb e cr con più occorrenze nell'istogramma
        cbHistMax = find(histcb == max(histcb),1);
        crHistMax = find(histcr == max(histcr),1);
        
        %calcolo differenze assolute tra valori media,centroide e
        %istogramma
        centroidDiff = abs(cbMean-cbCentroid) + abs(crMean-crCentroid);
        histDiff = abs(cbMean-cbHistMax) + abs(crMean-crHistMax);

        %scelgo se tenere istogramma o centroide in abse alla differenza
        %dalla media (serve quando ad esempio il centroide non è nelle
        %immagine come il pezzo a C) 
        if centroidDiff < histDiff
            cbMean = cbCentroid;
            crMean = crCentroid;
        else
            cbMean = cbHistMax;
            crMean = crHistMax;
        end
        
        %rifaccio segmentazione per cbcr sul singolo oggetto con il valori
        %che ho scelto prima e tolleranza 5% successivamente chiudo i buchi
        %che si formano
        mask2 = threshYCbCrMeanVariable(ycbcrMask,cbMean,crMean,0.03);
        mask2 = imfill(mask2,'holes');



        ycbcrMask2 = usingTr.*uint8(mask2);
        stdbY = std2(nonzeros(ycbcrMask2(:,:,1)));
        %se la deviazione standar è rimasta > di 25 significa che ci sono
        %ancora ombre (dati presi da immagini di training) in questo caso
        %rifaccio i passaggi di primi un altra volta
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
       %unisco la maschera singola al totale
       tmp = tmp + mask2;

    end
     tmp = imclose(tmp,strel('disk',55));
     out_seg = tmp;
end

function m = moment(image,mask,p,q)
% Function to calculate any ordinary moment of the intersted image region
% Author:   Vishnu Muralidharan
% University of Alabama in Huntsville

% Inputs:   image: input image for which moments need to be calculated
%           mask: specifying this allows you to calculate moments for a
%           specified region
%           p,q: order of moments to be calculated
% Outputs:  m = moment of the specifed order fot the image
% Reference:  Visual Pattern Recognition by Moment Invariants


if ~exist('mask','var')
    mask = ones(size(image,1),size(image,2));   %if mask is not specified, select the whole image
end

image = double(image);
m=0; 
for i=1:1:size(mask,1)
    for j=1:1:size(mask,2)
        if mask(i,j) == 1
            m = m + (double((image(i,j))*(i^p)*(j^q))) ; %moment calculation
        end
    end
end
end