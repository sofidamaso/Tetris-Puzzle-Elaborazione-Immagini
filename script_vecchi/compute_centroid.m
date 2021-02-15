%{
    COMPUTE_CENTROID

    https://it.mathworks.com/matlabcentral/answers/322369-find-centroid-of-binary-image
    https://it.mathworks.com/matlabcentral/answers/24212-show-the-position-of-centroids-on-the-image
%}

function centroid = compute_centroid(img)

[y, x] = ndgrid(1:size(img, 1), 1:size(img, 2));
centroid = mean([x(logical(img)), y(logical(img))]);

end


%{
    Per visualizzare le imamgini con i centroidi:

    imshow(img);
    hold(imgca,'on');
    plot(centroid(:,1), centroid(:,2), 'r*');
%}