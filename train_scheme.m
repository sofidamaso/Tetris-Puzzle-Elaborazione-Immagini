%{
    TRAIN_SCHEME
    
    Legge le immagini di training e calcola le signature per ogni immagine.
    Ogni immagine rappresenta una classe.
%}

function signatures = train_scheme()
    
    D = 'training_schema';
    S = dir(fullfile(D,'*.jpg')); % pattern to match filenames.
    
    for k = 1:numel(S)
        F = fullfile(D,S(k).name);
        I = imread(F);
        tmp = train_image(I);
        signatures{k} = tmp{1};
        a = 1;
    end
  end

function signatures = train_image(im)
    imgr = im;
    imbw = im2bw(imgr,graythresh(imgr));
    imlab = scheme_labelling(imbw);
    tmp_sign = get_signatures(imlab);
    signatures{1} = [];
    for i= 1 : max(max(imlab))
        signatures{1} = cat(1,signatures{1},tmp_sign{i});
    end
end
