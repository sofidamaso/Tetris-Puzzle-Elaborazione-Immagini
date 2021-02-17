clear all;
close all;
Dgt_scene = 'gt/groundtruth_scene_seg';


DScene = 'scene';






Sc = dir(fullfile(DScene,'*.jpg'));
tot = 0;

%scorro i file nella cartella scene
for k =1 : size(Sc,1)
    filename = fullfile(DScene,Sc(k).name);
   	
    
    %leggo l'immagine corrente e la segmento
    scene = imread(filename);
   
    
    predicted = scene_segmentation(scene);
    %leggo la gt associata nella cartella gt/groundtruth_scene_seg 
    gt_filename = fullfile(Dgt_scene,Sc(k).name);
    %trasformo gt in logical
    gt = im2gray(imread(gt_filename)) > 0;
    %calcolo la confmat tra gt e predicted
    tmp_conf = confmat(gt,predicted);
    
    
    accuracy{k}{2} = tmp_conf.accuracy;
    tot = tot + tmp_conf.accuracy;
    accuracy{k}{1} = Sc(k).name;
end
%media di tutte accuracy
mean = tot/size(Sc,1);
