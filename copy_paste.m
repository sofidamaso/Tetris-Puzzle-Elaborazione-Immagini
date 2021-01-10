%{
    COPY_PASTE
    
    Assumiamo che il tetramino sia già ruotato nella maniera corretta.
    Assumiamo che le immagini di input abbiano le stesse dimensioni.

    input:

        - immagine dei tetramini R
        - immagine dello schema S
        - maschera del tetramino in questione maskR
        - maschera dello schema del tetramino maskS
    
    algoritmo:

        1. calcoliamo le aree degli oggetti delle maschere (aR, aS)

        2. Troviamo il rapporto tra aS e aR (scale)
           ridimensioniamo R e maskR

        3. calcoliamo i centroidi degli oggetti delle maschere (cR, cS)
           usiamo la funzione compute_centroid(img)

        4. calcoliamo la distanza cS-cR (d)
           trasliamo maskR
           trasliamo R

        5. croppiamo R e maskR

        6. copiamo e incolliamo il tetramino sull'immagine
%}

function out = copy_paste(R,S,maskR,maskS)

% calcoliamo le aree degli oggetti delle maschere
aR = sum(maskR, 'all');
aS = sum(maskS, 'all');

% ridimensionamento
scale = aS/aR;
R = imresize(R,sqrt(scale));
maskR = imresize(maskR,sqrt(scale));

% calcoliamo i centroidi 
cR = int32(compute_centroid(maskR));
cS = int32(compute_centroid(maskS));

% traslazione affinché cS == cR
d = cS-cR;
maskR = imtranslate(maskR,d);
R = imtranslate(R,d);

% crop 
maskR = maskR(1:size(S,1), 1:size(S,2));
R = R(1:size(S,1), 1:size(S,2), 1:3);

% copia e incolla
red = R(:,:,1) .* (maskR); 
green = R(:,:,2) .* (maskR);
blue = R(:,:,3) .* (maskR);

tetramino = cat(3,red,green,blue); % singolo tetramino

maskR_n = not(maskR); % maschera singolo tetramino - negativo

red = S(:,:,1) .* maskR_n + tetramino(:,:,1);
green = S(:,:,2) .* maskR_n + tetramino(:,:,2);
blue = S(:,:,3) .* maskR_n + tetramino(:,:,3);

out = cat(3,red,green,blue);

end

%{
    Per visualizzare le imamgini con i centroidi:

    imshow(img);
    hold(imgca,'on');
    plot(centroid(:,1), centroid(:,2), 'r*');
%}

% TODO: e se aS è più piccola di aR? Dobbiamo mettere un controllo?
