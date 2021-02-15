%{
    SIGNATURE_MATCHING

    Input: signature di un pezzo dello schema e di un pezzo della scena
    Output: distanza minima fra le signature di schema e scena

%}

function match = signature_matching(scheme_signatures,scene_signatures)

min_dist = -1;

%scorro ogni signature dello schema
for i=1 : size(scheme_signatures,1)

    %scorro ogni signature della scena
    for j=1 : size(scene_signatures,1)
    
        %calcolo distanza euclidea tra signature i dello schema e
        %signature j della scena
        d = euclidean_distance(scheme_signatures(i,:),scene_signatures(j,:));

        %tengo la distanza minima
        if min_dist == -1
            min_dist = d;
        
        elseif d < min_dist
                min_dist = d;
        end
    end
end

match = min_dist;
end

function dist = euclidean_distance(sign1,sign2)
    if size(sign1,2) < size(sign2,2)
        big = sign2;
        small = sign1;
        
    else
        big = sign1;
        small = sign2;
    end
    
    dist = 0.0;
    for i = 1 : size(small,2)
        dist = dist + (big(i) - small(i))^2;
    end
    
    dist = dist^0.5;
end