clear;
close all;

load("modelli\cart2.mat");
% load("modelli\sfa.mat");
% load("modelli\second.mat");
% load("modelli\knn.mat");
load("modelli\classifier_cart_arcobaleno.mat");

% 
% frame = imread("media\frame_test_6_pazzo_sgravato.JPG");
% frame = imread("media\test2.jpg");
% frame = imread("media\frame_test_3.JPG");
frame = imread("testing\1_frame_test.JPG");
% frame = imread("media\test1.jpg");
tic;
image = pre_processing(frame);

[r, c, ch] = size(image);
r = floor(r/3);
c = floor(c/3);
image = imresize(image, [r,c]);
start = image;
im = rgb2ycbcr(image);
imlab = rgb2lab(image);
imh = rgb2hsv(image);
 pixs = reshape(image, r*c, 3);
 pixsy = reshape(im, r*c, 3);
 pixslab = reshape(imlab, r*c, 3);  
 pixsh = reshape(imh, r*c, 3);





% cb = im(:, :, 3);
% tcb = graythresh(cb);
% cb = imbinarize(cb, tcb);
a = imlab(:, :, 2);
ta = graythresh(a);
a = imbinarize(a, ta);
rr = image(:, :, 1);
trr = graythresh(rr);
rr = imbinarize(rr, trr);
otsu =  a & rr;
otsu = bwareaopen(otsu, max(r,c), 4);
image = image.*otsu;


predictedav = predict(cart, cat(2, pixs, pixslab(:, 2), pixsh(:, 3)));
% predictedav = bwareaopen(otsu, max(r,c), 4);
predictedycr = predict(cart2, cat(2, pixs, pixsy(:, [1,3])));
se = strel("disk", 10);
% predictedav = predict(cart_AV, cat(2, pixslab(:, 2), pixsh(:, 3)));
% 
% predictedycr = predict(cart_YCr, pixsy(:, [1,3]));

figure(3), subplot(1, 4, 1), imshow(reshape(predictedav, r,c)), title("av");
subplot(1, 4, 2), imshow(reshape(predictedycr, r,c)), title("ycr");
predicted = (predictedav + predictedycr) .* 0.5;

predicted = reshape(predicted, r,c,1);
subplot(1, 4, 3), imshow(predicted), title("predicted");
subplot(1, 4, 4), imshow(otsu), title("otsu");


predicted2 = propagate(predicted, otsu, r, c);
toc;

show_result(start, predicted, predicted2);
 
% se c'è la groundtruth
% gt = imread("testing\GT\5_frame_redmi_gt.png");
% [rgt, cgt, chgt] = size(gt);
% rgt = floor(rgt/3);
% cgt = floor(cgt/3);
% gt = imresize(gt, [rgt, cgt]);
% gt = gt > 0;
% gt = gt(:, :, 1);
% cm = confmat(gt, predicted2);
% cm.cm



