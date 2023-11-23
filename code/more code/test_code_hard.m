clear;
load("Data.mat\SFA\Mean\Arcobaleno\classifier_cart_arcobaleno_v2.mat");
%background = im2double(imread("Frame\3_sfondo.jpg"));
frame = imread("Frame\Anna_2.jpg");    
gt = imread("Frame\Anna_2_gt.png") > 0;

predicted = processHard(frame, bayes_AV, bayes_YCr);

% resize
[r, c, ch] = size(frame);
r = floor(r/3);
c = floor(c/3);
frame = imresize(frame, [r, c]);

%background = imresize(background, [r, c]);
gt = imresize(gt, [r,c]);
gt = gt(:, :, 1);


show_result(frame, predicted, "Finale");

%show_result_background(frame, predicted, background);

%se c'è la groundtruth
cm = confmat(gt, predicted)
cm.cm

