function match = signature_matching(scheme_signatures,scene_signatures)
    min_dist = -1;
    for i=1 : size(scheme_signatures,1)
        for j=1 : size(scene_signatures,1)
            d = euclidean_distance(scheme_signatures(i,:),scene_signatures(j,:));
            if min_dist == -1
                min_dist = d;
            else
                if d < min_dist
                    min_dist = d;
                end
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