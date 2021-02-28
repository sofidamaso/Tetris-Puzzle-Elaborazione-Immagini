%{
    ISMATCHED

    Input: lista delle matrici dei match
    Output: matrice binaria. Le righe rappresentano lo schema, le colonne
    la scena. Laddove è presente un 1, vi è un match.
%}

function out_match = isMatched(match_list,scene_label,scheme_label)

disp = ones(max(max(scene_label))); % disponibilità pezzi della scena
disp_sch = ones(max(max(scheme_label))); % disponibilità pezzi dello schema
match = zeros(max(max(scheme_label)),max(max(scene_label)));

for i=1 : size(match_list,2) % scorro i pezzi dello schema
     m=match_list{i};
    for x=1 : size(match_list{i},1) % scorro i pezzi della scena che hanno match con il pezzo dello schema
        if disp(m(x))==1  && disp_sch(i) == 1 % se sia il pezzo dello schema che della scena sono disponibili assegno il match e metto le disponibilità a 0
            match(i,m(x))=1;
            disp(m(x))= 0;
            disp_sch(i) = 0;
        end
    end
end

out_match=match;

end
