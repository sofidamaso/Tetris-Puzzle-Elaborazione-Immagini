%{
    TETRIS_PUZZLE

    Main. Prende in input un'immagine di scena e un'immagine di schema.
    L'output è l'immagine di schema con i tetramini apposti. 
%}

function out = tetris_puzzle(scene,scheme)

scene = im2double(scene);
scheme = im2double(scheme);

% segmentazione 
scene_mask = scene_segmentation(scene);
scheme_mask = scheme_segmentation(scheme);

% labelling delle componenti connesse della scena
scene_labels = bwlabel(scene_mask);

% labelling delle componenti connesse dello schema
scheme_labels = scheme_labelling(scheme_mask);

% calcolo signature
scene_signatures = get_signatures(scene_labels);
scheme_signatures = get_signatures(scheme_labels);

% matching signature
load 'training_class.mat';
match = scheme_scene_match_mindist(training_class,scheme_signatures,scene_signatures);

matches = isMatched(match,scene_labels,scheme_labels);

% posizionamento

for i = 1:size(matches,1)
    for h = 1:size(matches,2)
        
        if matches(i,h) == 1
            mask_scene = (scene_labels == h);
            mask_scheme = (scheme_labels == i);
            scheme = placement(scene,scheme,mask_scene,mask_scheme);
        end
    end
end

out = scheme;

end
