%{
    SEGMENTATION_SCHEME
    
    Segmentazione a soglia fissa sul canale V dell'imamgine. Viene
    effettuata una closing sul nero. La maschera corrisponde alle
    componenti connesse con etichetta > 1. 
%}

function mask = segmentation_scheme(scheme)

scheme_hsv = rgb2hsv(scheme);
scheme_v = scheme_hsv(:,:,3);

% segmentazione soglia fissa
mask = scheme_v > 0.3;

% chiusura (del nero)
se = strel('square',5);
mask = imdilate((imerode(mask,se)),se);

% labelling delle componenti connesse
labels = bwlabel(mask);

mask = labels > 1;

end

