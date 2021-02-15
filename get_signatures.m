%{
    GET_SIGNATURES

    Input: matrice di label
    Ouput: una lista di matrici. Ogni elemento della lista è relativo ad 
    una label, ogni elemento è una matrice  ogni riga della matrice è una 
    possibile signature (sono le stesse ma traslate per i vari punti di 
    max).
    
    Per accedere ad una singola signature si usa
    output_funzione{numero_label}(numero_signature,:)
    
    Può essere usata sia per scene che per schemi.

%}

function signatures = get_signatures(label_image)

% scorro per ogni label dell'immagine
for i = 1 : max(max(label_image))

    % prendo la maschera della singola label
    mask = label_image == i;

    % calcolo centroide
    centroid_x = moment(mask,mask,1,0)/moment(mask,mask,0,0);
    centroid_y = moment(mask,mask,0,1)/moment(mask,mask,0,0);

    % calcolo bordo (esterno)
    bw = bwboundaries(mask,8,'noholes');
    b = bw{1};

    x = b(:,1);
    y = b(:,2);

    %calcolo distanza
    distances = sqrt((x - centroid_x).^2 + (y - centroid_y).^2);  

    % ricampiono il vettore distanza per avere esattamente 100 elementi
    % ho usato l'interpolazione
    s = size(distances,1)/100;

    for r = 1 : 100
        k = r*s;
        floor_r = floor(k);
        ceil_r =  ceil(k);
        if floor_r < 1
            floor_r = 1;
        end
        if ceil_r > size(distances,1)
            ceil_r = size(distances,1);
        end
        floor_value = distances(floor_r);
        ceil_value = distances(ceil_r);
        molt_floor = ceil_r - k;
        molt_ceil = 1-molt_floor;
        tmp_distance(r,1) = floor_value*molt_floor + ceil_value*molt_ceil; 
    end

    distances = tmp_distance;
    max_value = max(max(distances));
    min_value = min(min(distances));
    
    % trovo tutti i picchi non vicini (almeno lontani 5) e che abbiano valore
    % almeno del 70% del max
    [peaks,locs] = findpeaks(distances,'MinPeakDistance',5,'MinPeakHeight',max_value*0.70);

    norm_distances = zeros(size(locs,1),size(distances,1));

    % creo tutte le signature tralsate per i picchi trovati e le
    % normalizzo da 0 a 1;
    for h=1 : size(locs,1) 
        if(locs(h) ~= 1)
            norm_distances(h,:) = cat(1,distances(locs(h):end),distances(1:locs(h)-1));
        else
            norm_distances(h,:) = distances;
        end
        norm_distances(h,:) = (norm_distances(h,:) - min_value)/(max_value-min_value);
    end

    signatures(i) = {norm_distances};
end

end