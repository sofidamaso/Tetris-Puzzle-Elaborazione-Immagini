function out_match = isMatched(match_list,scheme_im,scene_im)
%input: lista delle matrici dei match
%output: matrice binaria dove se M[i][j]=1 allora si matcha la label i dello schema con la label j della scena 
%NB:dato che i match sono ordinati in base alla distanza euclidea in modo
%crescente (il primo match è il più 'simile') utilizzo solo la prima
%colonna delle matrici, senza nemmeno considerare le distanze 



%codice labelling copiato da scheme_scene_matching
scheme_bw = im2bw(im2gray(scheme_im),graythresh(im2gray(scheme_im)));
    scheme_bw = bwareaopen(scheme_bw,1000);
    scheme_label = scheme_labelling(scheme_bw);
    scene_seg = scene_segmentation(scene_im);
    scene_seg = bwareaopen(scene_seg,1000);
    scene_label = bwlabel(scene_seg);
    
disp=ones(max(max(scheme_label)));
match=zeros(max(max(scheme_label)),max(max(scene_label)));
size_list=size(match_list);
for i=1 : size_list(2)   %scorro le matrici delle label
     m=match_list{i};
     size_list_i=size(m);
    for x=1 : size_list_i(1)    %scorro la prima colonna (y=1) della matrice della label i
        y=1;
        if disp(i)==1        %se disponibilità del pezzo è 1 allora posso assegnarlo e poi mettere disponibilità a 0 
            match(i,m(x,y))=1;
            disp(i)= 0;
        end
    end
end
out_match=match;
end

