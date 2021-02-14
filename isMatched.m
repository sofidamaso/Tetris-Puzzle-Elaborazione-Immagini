function out_match = isMatched(match_list,scheme_label,scene_label)
%input: lista delle matrici dei match, labelling di schema e scena
%output: matrice binaria dove se M[i][j]=1 allora si matcha la label i dello schema con la label j della scena 
%NB:dato che i match sono ordinati in base alla distanza euclidea in modo
%crescente (il primo match è il più 'simile') utilizzo solo la prima
%colonna delle matrici della match_list, senza nemmeno considerare le distanze 

% codice labelling copiato da scheme_scene_matching
% scheme_bw = im2bw(im2gray(scheme_im),graythresh(im2gray(scheme_im)));
%     scheme_bw = bwareaopen(scheme_bw,1000);
%     scheme_label = scheme_labelling(scheme_bw);
%     scene_seg = scene_segmentation(scene_im);
%     scene_seg = bwareaopen(scene_seg,1000);
%     scene_label = bwlabel(scene_seg);
    
disp=ones(max(max(scheme_label)));
match=zeros(max(max(scheme_label)),max(max(scene_label)));
size_list=size(match_list);
for i=1 : size_list(2)   %scorro le matrici delle label
     m=match_list{i};
     size_list_i=size(m);
    for x=1 : size_list_i(1)    %scorro la prima colonna (y=1) della matrice della label i
        %y=1;
        if disp(i)==1        %se disponibilità del pezzo è 1 allora posso assegnarlo e poi mettere disponibilità a 0 
            match(i,m(x))=1;
            disp(i)= 0;
        end
    end
end

%per gestire il fatto che nello schema possono esserci piu pezzi uguali ma
%che non sono disponibili nella scena bisogna imporre che per ogni colonna
%(ovvero per ogni label di scena) ci sia solo 1 match nello schema
%Esempio: se nello schema si hanno 2 pezzi che nella scena matchano con lo
%stesso pezzo allora alla fine si deve avere 1 solo pezzo di schema
%associato a quello della scena poichè non si hanno 2 pezzi di quel tipo
%nella scena che possano completare il tetris

size_match=size(match);
for j=1 : size_match(2)
    for i=1 : size_match(1)
        if match(i,j)==1
            for z=i+1 : size_match(2)
                   match(z,j)=0;        %
            end
        end
    end
end
out_match=match;
end
