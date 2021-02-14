%input: signature di training
%       immagine schema
%       immagine scena
%output: lista dei match è formata del tipo
%        output{i} lista match del label schema i
%        se ad esempio la label schema 2 matcha con label scena 5 e 8
%        output{2} = [ 5 8 ]
function match = scheme_scene_match_mindist(training_signatures,scheme_im,scene_im)
    tic
    %faccio le varie segnmentazione e labelling 
    %tolgo componenti con area < 50000px (da decidere)
    scheme_bw = im2bw(im2gray(scheme_im),graythresh(im2gray(scheme_im)));
    scheme_bw = bwareaopen(scheme_bw,50000);
    scheme_label = scheme_labelling(scheme_bw);
    scene_seg = scene_segmentation(scene_im);   
    scene_seg = bwareaopen(scene_seg,50000);
    scene_label = bwlabel(scene_seg);
    %prendo le signature dello schema e della scena
    scheme_signatures = get_signatures(scheme_label);
    scene_signatures = get_signatures(scene_label);
    
    %liste di associazioni di schema e scena alle classi di training
 
    scheme_class_list = signature_mindist_classifier(training_signatures,scheme_signatures);
    scene_class_list = signature_mindist_classifier(training_signatures,scene_signatures);
  
    %classe -1 = non trovata
    
    %adesso ho le liste delle classi associate alle varie label
    %creo quindi la lista di match
    for i = 1 : size(scheme_class_list,2)
        tmp =[];
        for j = 1 : size(scene_class_list,2)
            %se label schema e scena hanno stessa classe inserisco il match
            if scheme_class_list(i) == scene_class_list(j) && scheme_class_list(i) ~= -1
                tmp = cat(1,tmp,j);
                
            end
        end 
        match{i} = tmp;
    end
    toc
end