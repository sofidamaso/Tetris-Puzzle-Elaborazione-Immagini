function out_match = isMatched(match_list)
%input: lista delle matrici dei match
%output: matrice binaria dove se M[i][j]=1 allora si matcha la label i dello schema con la label j della scena 
%NB:dato che i match sono ordinati in base alla distanza euclidea in modo
%crescente (il primo match è il più 'simile') utilizzo solo la prima
%colonna delle matrici, senza nemmeno considerare le distanze 
disp=ones(size(match_list(1)));
match=zeros(max(max(scheme_label)),max(max(scene_label)));
for i=1 : size(match_list)   %scorro le matrici delle label
     m=match_list{i};
    for x=1 : size(m(1))    %scorro la prima colonna (y=1) della matrice della label i
        y=1;
        if disp(i)==1       %se disponibilità del pezzo è 1 allora posso assegnarlo e poi mettere disponibilità a 0 
            match(i,m(x,y))=1;
            disp(i)=0;
        end
    end
end
out_match=match;
end

