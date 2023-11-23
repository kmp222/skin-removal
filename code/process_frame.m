function result = process_frame(frame, background, cart, cart2)
  
%caricare due classificatori, questo caso due cart.
%Il primo per lo spazio av (lab-hsv) e il secondo per ycr (ycbcr).

image = pre_processing(frame);

%resize dell'immagine per ridurre i tempi computazionali.
[r, c, ch] = size(image);
r = floor(r/3);
c = floor(c/3);
image = imresize(image, [r,c]);
background = imresize(background, [r,c]);

%Converto l'immagine in diversi spazi colore utili e ristrutturo i dati.
im = rgb2ycbcr(image);
imlab = rgb2lab(image);
imh = rgb2hsv(image);
pixs = reshape(image, r*c, 3);
pixsy = reshape(im, r*c, 3);
pixslab = reshape(imlab, r*c, 3);  
pixsh = reshape(imh, r*c, 3);


%uso otsu per determinare automaticamante la soglia con cui binarizzare 
%per i canali cb (ycbcr), a (lab) e r (rgb)
cb = im(:, :, 3);
tcb = graythresh(cb);
cb = imbinarize(cb, tcb);
a = imlab(:, :, 2);
ta = graythresh(a);
cb = imbinarize(a, ta);
rr = image(:, :, 1);
trr = graythresh(rr);
rr = imbinarize(rr, trr);
%combino il risultato in una maschera 
otsu = cb & a & r;
%"riduco" la scena nell'immagine considerando solo le regioni identificate
%da otsu (che contengono con alta probabilità regioni di pelle)
image = image.*otsu;


%Fase critica: utilizzo due classificatori.
%Il risultato è un'immagine ternaria dove i pixel quindi possono avere
% valore 0, 1 e 2, rispettivamente indicando pixel non di pelle, pixel che 
% potrebbero essere di pelle e pixel che sono pelle.
predictedav = predict(cart, cat(2, pixs, pixslab(:, 2), pixsh(:, 3)));
predictedycr = predict(cart2, cat(2, pixs, pixsy(:, [1,3])));
predicted = (predictedav + predictedycr) .* 0.5;
%elimino eventuali pixel spurei che sono stati mal classificati.
predicted = bwareaopen(predicted, 3);

predicted = reshape(predicted, r,c,1);
%eseguo la funzione di propagate della maschera: l'obiettivo è 
%riuscire a classificare le zone grigie della maschera e chiudere 
%eventuali buchi.
predicted2 = propagate(predicted, otsu, r, c);

%Step finale, mostro il risultato dell'elaborazione
mask3 = double(repmat(predicted2,[1,1,ch]));
region = im2double(background).*mask3;

 maskInv = 1 - predicted2;
 mask3_Inv = double(repmat(maskInv, [1, 1, ch]));
 final = im2double(image).*mask3_Inv;
result = region + final;



end