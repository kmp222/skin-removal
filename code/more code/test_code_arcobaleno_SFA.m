clear;
close all;

load("Data.mat\SFA\Mean\Arcobaleno\classifier_cart_arcobaleno_v2.mat");

image  = imread("Frame\3_frame_test.JPG");
gt = imread("Frame\3_frame_test_gt.png") > 0;    
gt = gt(:, :, 1);

%image = pre_processing(image);
image = pre_processingAWB(image);

[r, c, ch] = size(image);
tic;
%Converto l'immagine in diversi spazi colore utili e ristrutturo i dati.
imYCbCr = rgb2ycbcr(image);
imLab = rgb2lab(image);
imHSV = rgb2hsv(image);

% reshape in triplette
pixsRGB = reshape(image, r*c, 3);
pixsYCbCr = reshape(imYCbCr, r*c, 3);
pixsLab = reshape(imLab, r*c, 3);  
pixsHsv = reshape(imHSV, r*c, 3);

% YCr
Y = pixsYCbCr(:, 1);
Cr = pixsYCbCr(:, 3);
pixsYCr = cat(2, Y, Cr);

% AV
A = pixsLab(:, 2);
V = pixsHsv(:, 3);
pixsAV = cat(2, A, V);

% CART RGB
% predicted_RGB = predict(cart_RGB, pixsRGB);
% predicted_RGB = reshape(predicted_RGB, r, c) > 0;
% show_result(image, predicted_RGB, "Cart RGB");
% cm = confmat(gt, predicted_RGB);
% disp("\n\n Cart RGB \n");
% disp(cm.cm);

% CART YCbCr
% predicted_YCbCr = predict(cart_YCbCr, pixsYCbCr);
% predicted_YCbCr = reshape(predicted_YCbCr, r, c) > 0;
% show_result(image, predicted_YCbCr, "Cart YCbCr");
% cm = confmat(gt, predicted_YCbCr);
% disp("\n\n Cart YCbCr \n");
% disp(cm.cm);

% CART YCr
predicted_YCr = predict(cart_YCr, pixsYCr);
predicted_YCr = reshape(predicted_YCr, r, c) > 0;
show_result(image, predicted_YCr, "Cart YCr");
cm = confmat(gt, predicted_YCr);
disp("\n\n Cart YCr \n");
disp(cm.cm);
% KNN YCr
predicted_Knn_YCr = predict(knn_YCr, pixsYCr);
predicted_Knn_YCr = reshape(predicted_Knn_YCr, r, c) > 0;
show_result(image, predicted_Knn_YCr, "KNN YCr");
cm = confmat(gt, predicted_Knn_YCr);
disp("\n\n KNN YCr \n");
disp(cm.cm);
% Bayes YCr
predicted_bayes_YCr = predict(bayes_YCr, pixsYCr);
predicted_bayes_YCr = reshape(predicted_bayes_YCr, r, c) > 0;
show_result(image, predicted_bayes_YCr, "Bayes YCr");
cm = confmat(gt, predicted_bayes_YCr);
disp("\n\n Bayes YCr \n");
disp(cm.cm);


% CART AV
predicted_AV = predict(cart_AV, pixsAV);
predicted_AV = reshape(predicted_AV, r, c) > 0;
show_result(image, predicted_AV, "Cart AV");
cm = confmat(gt, predicted_AV);
disp("\n\n Cart AV \n");
disp(cm.cm);
% KNN AV
predicted_Knn_AV = predict(knn_AV, pixsAV);
predicted_Knn_AV  = reshape(predicted_Knn_AV , r, c) > 0;
show_result(image, predicted_Knn_AV , "KNN AV");
cm = confmat(gt, predicted_Knn_AV );
disp("\n\n KNN AV \n");
disp(cm.cm);
% Bayes AV
predicted_Bayes_AV = predict(bayes_AV, pixsAV);
predicted_Bayes_AV = reshape(predicted_Bayes_AV, r, c) > 0;
show_result(image, predicted_Bayes_AV, "Bayes AV");
cm = confmat(gt, predicted_Bayes_AV);
disp("\n\n Bayes AV \n");
disp(cm.cm);


toc;