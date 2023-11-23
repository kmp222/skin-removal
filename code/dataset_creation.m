clear;
close all;
file = readtable('Skin_NonSkin.txt');

file_features = table2array(file(:, 1:3));
file_labels = table2array(file(:, 4));
file_features = file_features ./ 255;

dataset = cat(2,file_features, file_labels);