% input: immagine schema segmentato (linee schema in nero e resto bianco)
% output: immagine labelling
% (magari conviene fare un filtraggio sulla segmentazione es. mediano?)

function out_labels = scheme_labelling(bw)
    %calcolo le label
    tmp_lab = bwlabel(bw);
    n_label = max(max(tmp_lab));
    %la label con più perimetro comune alle righe nere (assumo?) sia lo
    %sfondo bianco esterno
    %calcolo i perimetri comuni alle righe nere
    common_perimeters = zeros(n_label);
    for i = 0 : max(n_label)
        common_perimeters = count_common_perimeter4c(tmp_lab,i);
    end
    %elimino la label con perimetro comune maggiore
    min_index = find(common_perimeters == min(common_perimeters),1);
    
    mask = (tmp_lab == min_index) .* min_index;
    
    tmp_lab = tmp_lab-mask;
    
    for i = min_index+1 : n_label
        mask = (tmp_lab == i);
        tmp_lab = tmp_lab-(mask.*i) + (mask.*(i-1));
    end
    out_labels = tmp_lab;
end

%funzione che calcola perimetro comune
function common_perimeter = count_common_perimeter4c(label_im,label)
    common_perimeter = 0;
    for i = 1 : size(label_im,1)
        for j = 1 : size(label_im,2)
            if label_im(i,j) == label
               if i < size(label_im,1)
                    if label_im(i+1,j) == 0
                        common_perimeter = common_perimeter + 1;
                    end
               end
               if i > 1
                    if label_im(i-1,j) == 0
                        common_perimeter = common_perimeter + 1;
                    end
               end
               
               if j < size(label_im,2)
                    if label_im(i,j+1) == 0
                        common_perimeter = common_perimeter + 1;
                    end
               end
               if j > 1 
                    if label_im(i,j-1) == 0
                        common_perimeter = common_perimeter + 1;
                    end
               end
            end
        end
    end

end