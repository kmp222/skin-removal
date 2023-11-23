function predictedFinal = processHard(frame, classsifier_AV, classifier_YCr)
    image = pre_processingAWB(frame);
    % resize image
    [r, c, ch] = size(frame);
    r = floor(r/3);
    c = floor(c/3);
    image = imresize(image, [r, c]);

    
    % CONVERSIONE spazi colore
    imYCbCr = rgb2ycbcr(image);
    imLab = rgb2lab(image);
    imHSV = rgb2hsv(image);
    
    % RESHAPE dei vari canali
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
    

    %%% OTSU
    % per i canali cb (YCbCr)
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
    
    % Combino in AND il risultato - HARD Cb
    otsu = cb & a & r;
    % elimino regioni spurie
    otsuBw = bwareaopen(otsu, floor(max(r, c)), 4);
    
    % risultato
    imageOtsu = image.*otsuBw;
    
    % Dati per i classificatori
    otsuYCbCr = rgb2ycbcr(imageOtsu);
    otsuLab = rgb2lab(imageOtsu);
    otsuHSV = rgb2hsv(imageOtsu);
    
    
    %%% MULTI-CLASSIFICATORE
    % Bayesiano / Cart AV
    predicted_AV = predict(classsifier_AV, pixsAV);
    predicted_AV = reshape(predicted_AV, r, c) > 0;
    predicted_AV = bwareaopen(predicted_AV, floor(max(r, c)/5), 4);
    show_result(image, predicted_AV , "Bayes AV");
    
    % Bayesiano YCr
    predicted_YCr = predict(classifier_YCr, pixsYCr);
    predicted_YCr  = reshape(predicted_YCr, r, c) > 0;
    predicted_YCr = bwareaopen(predicted_YCr, floor(max(r, c)/8), 8);
    show_result(image, predicted_YCr  , "Bayes YCr");
    
    % Ternaria
    predictedTernaria = (predicted_AV  + predicted_YCr) .* 0.5;
    predictedTernaria = reshape(predictedTernaria, r, c,1);
    
    % HARD Propagate
    predictedFinal = propagateHard(predictedTernaria, otsuBw, r, c);
    
end