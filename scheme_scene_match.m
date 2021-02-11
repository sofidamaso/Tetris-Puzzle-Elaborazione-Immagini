%input: immagine schema, immagine scena, (il folder mi serviva per salvare
%       le foto poi si toglierà)
%%output: per ora nulla poi metterei la lista dei match

function match = scheme_scene_match(scheme_im,scene_im,folder)
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
    
    %scorro tuttel le label di schema e scena
    %per ogni pezzo dello schema tengo come match il pezzo della scena che
    %ha distanza più piccola e < di 1.6
    for i=1 : max(max(scheme_label))
        dmin = -1;
        scheme_min = [];
        scene_min = [];
        
        for j = 1 : max(max(scene_label))
            %calcolo distanza
            d = signature_matching(scheme_signatures{i},scene_signatures{j});
            mask_scheme = scheme_label == i;
            mask_scene = scene_label == j;
            
            
            if d < 1.6
                
                %(qua metteremo il match ora salvo solo le immagini per
                %stamparle)
                if dmin == -1
                    dmin = d;
                    scheme_min = uint8(mask_scheme).*scheme_im;
                    scene_min = uint8(mask_scene).*scene_im;
                else
                    if d < dmin
                         dmin = d;
                        scheme_min = uint8(mask_scheme).*scheme_im;
                        scene_min = uint8(mask_scene).*scene_im;
                    end
                end
            end
            
        end
        %se c'è stato un match mi salvo l'immagine
        if dmin ~= -1
            figure
                subplot(1,2,1),imshow(scheme_min),subplot(1,2,2),imshow(scene_min)
                saveas(gcf,strcat(folder,'/dist',num2str(dmin),'.jpg'));
                close all;
        end
        
    end
end