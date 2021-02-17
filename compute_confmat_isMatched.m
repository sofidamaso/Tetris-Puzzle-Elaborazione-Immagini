clear all;
close all;
load training_class.mat
Dgt_match = 'gt/groundtruth_match';

DScheme = 'schemi';
DScene = 'scene';

Gt_m = dir(fullfile(Dgt_match,'*.txt'));




Sch = dir(fullfile(DScheme,'*.jpg'));

Sc = dir(fullfile(DScene,'*.jpg'));

%scorro le gt di match (cartella gt/groundtruth_match)
for k =1 : size(Gt_m,1)
    filename = fullfile(Dgt_match,Gt_m(k).name);
    %leggo la gt e trovo i file di scena e schema associati prendendoli dal
    %nome della gt
    f = fopen(filename);
    data = textscan(f,'%s','Delimiter','\n');
    fclose(f);
    tmp = erase(Gt_m(k).name,'.txt');
    tmp = strsplit(tmp,'_');
    scheme_name = strcat( tmp{2},'.jpg');
    scheme_name = fullfile(DScheme,scheme_name);
    scene_name = strcat(tmp{3},'.jpg');
    scene_name = fullfile(DScene,scene_name);
    scheme = imread(scheme_name);
    scene = imread(scene_name);
    gt = zeros(size(data{1},1),size(str2num(data{1}{1}),2));
    %leggo il file di testo della gt e lo metto in matrice
    for i=1 : size(data{1},1)
        gt(i,:) = str2num(data{1}{i});
        
    end
    
    %effettuo le operazione del main fino a isMatched
    scheme = im2double(scheme);

    % segmentazione 
    scene_mask = scene_segmentation(scene);
    scheme_mask = scheme_segmentation(scheme);

    % labelling delle componenti connesse della scena
    scene_labels = bwlabel(scene_mask);

    % labelling delle componenti connesse dello schema
    scheme_labels = scheme_labelling(scheme_mask);

    % calcolo signature
    scene_signatures = get_signatures(scene_labels);
    scheme_signatures = get_signatures(scheme_labels);

    % matching signature
    load 'training_class.mat';
    match = scheme_scene_match_mindist(training_class,scheme_signatures,scene_signatures);


    matches = isMatched(match,scene_labels,scheme_labels);
    %calcolo la confmat tra output,is_matched e gt
    tmp_conf = confmat(gt,matches);
    accuracy{k}{2} = tmp_conf.accuracy;
    
    accuracy{k}{1} = Gt_m(k).name;
end
