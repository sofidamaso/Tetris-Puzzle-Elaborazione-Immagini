%{ 
Rilevamento delle ombre. Prende in input il canale V di un'immagine e 
restituisce una maschera. Utilizza Sauvola. 
%}

function mask = shadow_mask(V)

    V_gauss = imfilter(V, fspecial('gaussian',[51 51], 10));
   
    V_filtered = (V + V_gauss) / 2;

    mask = sauvola(V_filtered, [71 71]);
end
