%{
    SIGNATURE_MINDIST_CLASSIFIER

%}

function label_class_list = signature_mindist_classifier(training_signatures,test_signatures)

for i=1 : size(test_signatures,2)
    distmin = -1;
    class = -1;

    for j = 1 : size(training_signatures,2)

        %calcolo distanza
        d = signature_matching(test_signatures{i},training_signatures{j});

        if d < 2
            
            if distmin == -1
                distmin = d;
                class = j;
            
            elseif d < distmin
                    distmin = d;
                    class = j;
            end
        end
    end
    
    label_class_list(i) = class;
end

end