clear all;
close all;
load training_class.mat
Dgt_scheme = 'gt/groundtruth_schemi';
Dgt_scene = 'gt/groundtruth_scene';
DScheme = 'schemi';
DScene = 'scene';

Gt_sch = dir(fullfile(Dgt_scheme,'*.txt'));

Gt_sc = dir(fullfile(Dgt_scene,'*.txt'));


Sch = dir(fullfile(DScheme,'*.jpg'));

Sc = dir(fullfile(DScene,'*.jpg'));
cont = size(Gt_sch,1);

gtscheme = [];
gtscene = [];

%leggo le gt_schema in relativa cartella e le carico nel vettore gtscheme
for k =1 : size(Gt_sch,1)
    filename = fullfile(Dgt_scheme,Gt_sch(k).name);
    f = fopen(filename);
    data = textscan(f,'%s','Delimiter','\n');

    
    fclose(f);
    
    gtscheme = cat(2,gtscheme,str2num(data{1}{1}));
end
%leggo le gt_scena in relativa cartella e le carico nel vettore gtscene
for k =1 : size(Gt_sc,1)
    filename = fullfile(Dgt_scene,Gt_sc(k).name);
    f = fopen(filename);
    data = textscan(f,'%s','Delimiter','\n');

    
    fclose(f);
    
    gtscene = cat(2,gtscene,str2num(data{1}{1}));
end

cont = size(Sch,1);
predscheme = [];
predscene = [];
%leggo immagini schema ed effettuo classificazione, poi carico in vettore
%predscheme
for k = 1:size(Sch,1)
   
       scheme = fullfile(DScheme,Sch(k).name);
       scheme_im = imread(scheme);
       scheme_bw = im2bw(im2gray(scheme_im),graythresh(im2gray(scheme_im)));
        scheme_bw = bwareaopen(scheme_bw,50000);
        scheme_label = scheme_labelling(scheme_bw);
        scheme_signatures = get_signatures(scheme_label);
       predscheme = cat(2,predscheme, signature_mindist_classifier(training_class,scheme_signatures));
end

%leggo immagini scena ed effettuo classificazione, poi carico in vettore
%predscene
for k = 1:size(Sc,1)
   
       scene = fullfile(DScene,Sc(k).name);
       scene_im = imread(scene);
       scene_seg = scene_segmentation(scene_im);   
        scene_seg = bwareaopen(scene_seg,50000);
        scene_label = bwlabel(scene_seg);
        scene_signatures = get_signatures(scene_label);
       predscene = cat(2,predscene,signature_mindist_classifier(training_class,scene_signatures));
       
       a = 1;
end
%calcolo confmat di schema e scena 
confmScheme = confmat(gtscheme,predscheme);
confScene = confmat(gtscene,predscene);
