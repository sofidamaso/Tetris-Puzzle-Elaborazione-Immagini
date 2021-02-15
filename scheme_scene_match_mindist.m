%{
    SCHEME_SCENE_MATCH_MINDIST

    Input: signature di training
    Output: lista dei match
       
    output{i} lista match del label schema i
    se ad esempio la label schema 2 matcha con label scena 5 e 8
    output{2} = [ 5 8 ]
%}

function match = scheme_scene_match_mindist(training_signatures,scheme_signatures,scene_signatures)
 
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
end