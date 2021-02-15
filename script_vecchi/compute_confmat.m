clear all;
close all;
load training_class.mat
Dgt_scheme = 'confmat/groundtruth_schemi';
Dgt_scene = 'confmat/groundtruth_scene';
DScheme = 'schemi';
DScene = 'scene';

Gt_sch = dir(fullfile(Dgt_scheme,'*.txt'));

Gt_sc = dir(fullfile(Dgt_scene,'*.txt'));


Sch = dir(fullfile(DScheme,'*.jpg'));

Sc = dir(fullfile(DScene,'*.jpg'));
cont = size(Gt_sch,1);

gt2 = [];

for k =1 : size(Gt_sch,1)
    filename = fullfile(Dgt_scheme,Gt_sch(k).name);
    f = fopen(filename);
    data = textscan(f,'%s','Delimiter','\n');

    
    fclose(f);
    
    gt{k} = str2num(data{1}{1});
    gt2 = cat(2,gt2,gt{k});
end

for k =1 : size(Gt_sc,1)
    filename = fullfile(Dgt_scene,Gt_sc(k).name);
    f = fopen(filename);
    data = textscan(f,'%s','Delimiter','\n');

    
    fclose(f);
    
    gt{cont + k} = str2num(data{1}{1});
    gt2 = cat(2,gt2,gt{k+cont});
end

cont = size(Sch,1);
pred2 = [];
for k = 1:size(Sch,1)
   
       scheme = fullfile(DScheme,Sch(k).name);
       scheme_im = imread(scheme);
       scheme_bw = im2bw(im2gray(scheme_im),graythresh(im2gray(scheme_im)));
        scheme_bw = bwareaopen(scheme_bw,50000);
        scheme_label = scheme_labelling(scheme_bw);
        scheme_signatures = get_signatures(scheme_label);
       predicted{k} = signature_mindist_classifier(training_class,scheme_signatures);
       predicted{k}
       pred2 = cat(2,pred2,predicted{k});
end


for k = 1:size(Sc,1)
   
       scene = fullfile(DScene,Sc(k).name);
       scene_im = imread(scene);
       scene_seg = scene_segmentation(scene_im);   
        scene_seg = bwareaopen(scene_seg,50000);
        scene_label = bwlabel(scene_seg);
        scene_signatures = get_signatures(scene_label);
       predicted{cont+k} = signature_mindist_classifier(training_class,scene_signatures);
    pred2 = cat(2,pred2,predicted{cont+k});
end

confm = confmat(gt2,pred2);
