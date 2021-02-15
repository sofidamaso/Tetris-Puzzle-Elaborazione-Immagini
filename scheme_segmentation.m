%{
    SCHEME_SEGMENTATION
    
    Segmentazione a soglia fissa sul canale V dell'imamgine. Viene
    effettuata una closing sul nero.
%}

function mask = scheme_segmentation(scheme)

scheme_hsv = rgb2hsv(scheme);
scheme_v = scheme_hsv(:,:,3);

% segmentazione soglia fissa
mask = scheme_v > 0.3;

% chiusura (del nero)
se = strel('square',5);
mask = imdilate((imerode(mask,se)),se);

end

