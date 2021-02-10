% input: un'immagine labelling
% ouput: una lista di matrici
% ogni elemento della lista è relativo ad una label, ogni elemento è una
% matrice  ogni riga della matrice è una possibile signature (sono le stesse
% ma traslate per i vari punti di max)
% per accedere ad una singola signature si usa: 
% output_funzione{numero_label}(numero_signature,:)
% funziona sia su schemi che scene

function signatures = get_signatures(label_image)
    % scorro per ogni label dell'immagine
    for i = 1 : max(max(label_image))
        
        % prendo la maschera della singola label
        mask = label_image == i;
%         close all;
%         imshow(mask)
        
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
        
        % ricampiono il vettore distanza per avere circa 100 elementi
        % (ho messo 100 a caso possiamo cambiare guardando quanto ci è
        % lunga la classificazione)
        s = size(distances,1);
        distances= distances(1:floor(s/100):end);
        
        max_value = max(max(distances));
        min_value = min(min(distances));
        % trovo tutti i picchi non vicini (almeno lontani 5) e che abbiano valore
        % almeno del 90% del max
        [peaks,locs] = findpeaks(distances,'MinPeakDistance',5,'MinPeakHeight',max_value*0.90);

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