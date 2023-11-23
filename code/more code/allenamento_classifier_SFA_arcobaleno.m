% skin
load("Data.mat\SFA\Mean\Arcobaleno\SFAskinRGB_MEAN_RGB_YCbCr_Lab_HSV.mat");
load("Data.mat\SFA\Mean\Arcobaleno\SFA_NO_skinRGB_MEAN_RGB_YCbCr_Lab_HSV.mat");

%%% OPERAZIONI PRELIMINARI %%%
% prelevo dal dataset gli RGB
skinRGB = im2double(skinMeanRGB);
noSkinRGB = im2double(noSkinMeanRGB);

% prelevo dal dataset YCbCr
skinYCbCr = im2double(skinMeanYCbCr);
noSkinYCbCr = im2double(noSkinMeanYCbCr);

% prelevo dal dataset Lab*
skinLab = skinMeanLab;
noSkinLab = noSkinMeanLab;

% prelevo dal dataset HSV
skinHSV = skinMeanHSV;
noSkinHSV = noSkinMeanHSV;

% le dimensioni tanti sono uguali per tutti gli spazi colore skin / noskin 
% con SFA 
% skin... = 3354, 
% noSkin... = 5590
rs = size(skinRGB, 1);
rns = size(noSkinRGB, 1);
train_labels = [ones(rs, 1); zeros(rns, 1)];


%%% CLASSIFICATORI SEMPLICI %%%
% classificatore RGB
train_values_RGB = [skinRGB; noSkinRGB]; 
cart_RGB = fitctree(train_values_RGB, train_labels);
knn_RGB  = fitcknn(train_values_RGB, train_labels);

% classificatore YCbCr
train_values_YCbCr = [skinYCbCr; noSkinYCbCr]; 
cart_YCbCr = fitctree(train_values_YCbCr, train_labels);
knn_YCbCr = fitcknn(train_values_YCbCr, train_labels);

%%% CLASSIFICATORI COMBINATI %%%

% classificatori AV (a di Lab, v di HSV)
skinAV = cat(2, skinLab(:, 2), skinHSV(:, 3));
noSkinAV = cat(2, noSkinLab(:, 2), noSkinHSV(:, 3));
train_values_AV = [skinAV; noSkinAV]; 

cart_AV = fitctree(train_values_AV, train_labels);
knn_AV = fitcknn(train_values_AV, train_labels);
bayes_AV = fitcnb(train_values_AV, train_labels);

% classificatore Cart YCr 
Yskin = skinYCbCr(:, 1);
YNoSkin = noSkinYCbCr(:, 1);
CrSkin = skinYCbCr(:, 3);
CrNoSkin = noSkinYCbCr(:, 3);
train_values_YCr = [cat(2, Yskin, CrSkin); cat(2, YNoSkin, CrNoSkin)];

cart_YCr = fitctree(train_values_YCr, train_labels);
knn_YCr = fitcknn(train_values_YCr, train_labels);
bayes_YCr = fitcnb(train_values_YCr, train_labels);

save("classifier_cart_arcobaleno_v2.mat", "cart_AV", "knn_AV", "bayes_AV", "cart_YCr", "knn_YCr", "bayes_YCr", "cart_RGB", "knn_RGB", "cart_YCbCr", "knn_YCbCr");