clear;

load("Data.mat\SFA\Mean\classifierKNNCartMeanSFA.mat");
load("Data.mat\Skin_NoSkin_Ciocca\classifier_Cart_Stupido.mat");

%background = im2double(imread("Frame\3_sfondo.jpg"));
%background = pre_processingAWB(background);

tic;
image  = im2double(imread("Frame\4_frame_test.JPG"));
image = pre_processingAWB(image);
%image = pre_processing(image);

[r, c, ch] = size(image);
pixs = reshape(image, r*c, 3);

% morfologia matematica
s = strel("disk", 5);

predicted_seria = predict(classifier_cart, pixs);
predicted_seria = reshape(predicted_seria, r, c) > 0;
bwopenMask = floor(r/3);
predicted_seria_bwareaopen = bwareaopen(predicted_seria , bwopenMask, 4);

predicted_stupida = predict(classifier_cart_stupido, pixs);
predicted_stupida = reshape(predicted_stupida, r, c) > 0;
predicted_stupida = imclose(predicted_stupida, s);
predicted_stupida = imdilate(predicted_stupida, s);
predicted_stupida_bwareaopen = bwareaopen(predicted_stupida, 200, 8);

predicted = predicted_seria_bwareaopen | predicted_stupida_bwareaopen;
toc;

figure();
predicted = imclose(predicted, s);
imshow(predicted), title("Somma");

%risultato finale
show_result(image, predicted);
%show_result_background(image, predicted, background);

%se c'è la groundtruth
gt = imread("Frame\4_frame_test_gt.png") > 0;
gt = gt(:, :, 1);
cm = confmat(gt, predicted)
cm.cm

