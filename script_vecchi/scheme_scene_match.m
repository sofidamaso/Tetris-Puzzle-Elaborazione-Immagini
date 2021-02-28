%input: immagine schema, immagine scena, (il folder mi serviva per salvare
%       le foto poi si toglierà)
%output: è una lista di matrici.
%        per accedere alla matrice della label i si usa output{i}
%        la matrice è composta da 2 colonne ed un numero di righe uguale ad
%        i match riscontrati. Prima colonna numero della label della scena
%        con cui è avvenuto il match. Seconda colonna distanza euclidea 
%        calcolata. Ad esempio se la label dello schema 2 ha match con la 
%        label della scena 1 con distanza 0.5 e 3 con distanza 0.2. 
%        output{2} sarà:
%        | 3 0.2 |
%        | 1 0.5 |
%        i match sono ordinati per distanza ( il primo match è il più
%        'simile')


function match = scheme_scene_match(scheme_im,scene_im)
    tic
    %faccio le varie segnmentazione e labelling 
    %tolgo componenti con area < 1000px (da decidere)
    scheme_bw = im2bw(im2gray(scheme_im),graythresh(im2gray(scheme_im)));
    scheme_bw = bwareaopen(scheme_bw,1000);
    scheme_label = scheme_labelling(scheme_bw);
    scene_seg = scene_segmentation(scene_im);
    scene_seg = bwareaopen(scene_seg,1000);
    scene_label = bwlabel(scene_seg);
    %prendo le signature dello schema e della scena
    scheme_signatures = get_signatures(scheme_label);
    scene_signatures = get_signatures(scene_label);
    
    
    
    %scorro tutte le label di schema e scena
    %per ogni pezzo dello schema tengo come match il pezzo della scena che
    %ha distanza più piccola e < di 1.6
    for i=1 : max(max(scheme_label))
        %lista dei match della label i dello schema
        match_list = [];
        for j = 1 : max(max(scene_label))
            %calcolo distanza
            d = signature_matching(scheme_signatures{i},scene_signatures{j});
           
            
            
            if d < 1.6
                
                %nel match oltre ad inserire la label della scena con cui
                %avviene il match (in questo caso j) inserisco anche la
                %distanza calcolata (potrebbe tornare utile)
                match_list = cat(1,match_list , [j d]);
               
            end
            
        end
        %riordino i match in base alla distanza 
        match_list = sortrows(match_list,2);
        match{i} = match_list;
        
    end
    toc
end
