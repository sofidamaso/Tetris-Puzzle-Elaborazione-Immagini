%{
    ISMATCHED

    Input: lista delle matrici dei match
    Output: matrice binaria. Le righe rappresentano lo schema, le colonne
    la scena. Liddove è presente un 1, vi è un match.
    
    NB: Per quanto riguarda la matrice in input, dato che i match sono 
    ordinati in base alla distanza euclidea in modo crescente (il primo 
    match è il più 'simile') utilizzo solo la prima colonna delle matrici, 
    senza nemmeno considerare le distanze 
%}

function out_match = isMatched(match_list,scene_label,scheme_label)

disp=ones(max(max(scheme_label)));
match=zeros(max(max(scheme_label)),max(max(scene_label)));

for i=1 : size(match_list,2)   %scorro le matrici delle label
     m=match_list{i};
    for x=1 : size(match_list{i},1)    %scorro la prima colonna (y=1) della matrice della label i
        if disp(i)==1        %se disponibilità del pezzo è 1 allora posso assegnarlo e poi mettere disponibilità a 0 
            match(i,m(x))=1;
            disp(i)= 0;
        end
    end
end

% per gestire il fatto che nello schema possono esserci piu pezzi uguali ma
% che non sono disponibili nella scena bisogna imporre che per ogni colonna
% (ovvero per ogni label di scena) ci sia solo 1 match nello schema
% Esempio: se nello schema si hanno 2 pezzi che nella scena matchano con lo
% stesso pezzo allora alla fine si deve avere 1 solo pezzo di schema
% associato a quello della scena poichè non si hanno 2 pezzi di quel tipo
% nella scena che possano completare il tetris

for j=1 : size(match,2)
    for i=1 : size(match,1)
        if match(i,j)==1
            for z=i+1 : size(match,1)
                   match(z,j)=0;        
            end
        end
    end
end

out_match=match;

end