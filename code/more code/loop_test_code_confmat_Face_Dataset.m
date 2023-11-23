clear;
close all;

load("Data.mat\SFA\Mean\Arcobaleno\classifier_cart_arcobaleno_v2.mat");

dinfo = dir('Face_Dataset/Pratheepan_Dataset/FamilyPhoto/*.jpg');
gtdinfo = dir('Face_Dataset/Ground_Truth/GroundT_FamilyPhoto/*.png');
accuracy = 0;
trueNegative = 0;
truePositive = 0;
falseNegative = 0;
falsePositive = 0;
n = length(dinfo);

for k = 1 : n  
    thisimage = dinfo(k).name;
    thisgt = gtdinfo(k).name;
    image = imread(['Face_Dataset/Pratheepan_Dataset/FamilyPhoto/' thisimage]);
    image = pre_processingAWB(image);
    [r, c, ch] = size(image);
    % resize image
    r = floor(r/3);
    c = floor(c/3);
    image = imresize(image, [r, c]);

    % reshape in triplette

    imYCbCr = rgb2ycbcr(image);
    imLab = rgb2lab(image);
    imHSV = rgb2hsv(image);
   
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
    
    % otsu per determinare automaticamante la soglia con cui binarizzare 
    % per i canali cb (YCbCr
    cb = imYCbCr(:, :, 3);
    tcb = graythresh(cb);
    cb = imbinarize(cb, tcb);
    
    % a (Lab)
    a = imLab(:, :, 2);
    ta = graythresh(a);
    a = imbinarize(a, ta);
    
    % r (RGB)
    rr = image(:, :, 1);
    trr = graythresh(rr);
    rr = imbinarize(rr, trr);
    
    %combino il risultato in una maschera 
    otsu = a & r;
    otsuBw = bwareaopen(otsu, floor(max(r, c)), 4);
    
    %"regioni identificate da otsu con alta probabilità di pelle
    imageOtsu = image.*otsuBw;
    
    % CLASSIFICATORE AV
    predicted_AV = predict(bayes_AV, pixsAV);
    predicted_AV = reshape(predicted_AV, r, c) > 0;
    predicted_AV = bwareaopen(predicted_AV, floor(max(r, c)/7), 4);
      
    % CLASSIFICATORE YCr
    predicted_YCr = predict(bayes_YCr, pixsYCr);
    predicted_YCr  = reshape(predicted_YCr, r, c) > 0;
    predicted_YCr = bwareaopen(predicted_YCr, floor(max(r, c)/8), 8);
    
    predictedTernaria = (predicted_AV  + predicted_YCr) .* 0.5;
    predictedTernaria = reshape(predictedTernaria, r, c,1);
    
    % facciamo un "torneo" sui pixel grigi
    % nel torneo, dove otsu è 0 sarà 0 indipendentemente dalla classificazione
    predictedFinal = propagate(predictedTernaria, otsuBw, r, c);
    
    
    gt = imread(['Face_Dataset/Ground_Truth/GroundT_FamilyPhoto/' thisgt]) > 0;
    gt = gt(:, :, 1);
    gt = imresize(gt, [r, c]);
    cm = confmat(gt, predictedFinal);
    accuracy = accuracy + cm.accuracy;
    trueNegative = trueNegative + cm.cm(1, 1);
    falseNegative = falseNegative + cm.cm(1, 2);
    falsePositive = falsePositive + cm.cm(2, 1);
    truePositive = truePositive + cm.cm(2, 2);
end

meanAccuracy = accuracy / n
meanTrueNegative = trueNegative / n;
meanFalseNegative = falseNegative / n;
meanFalsePositive = falsePositive / n;
meanTruePositive = truePositive / n;

Matrice_Confusione = [meanTrueNegative, meanFalseNegative; meanFalsePositive, meanTruePositive]


    