% skin
skin = im2double(imread("skin\skin2.png"));
[r, c, ch] = size(skin);
skin = reshape(skin, r*c, 3);

% no skin
noskin = im2double(imread("skin\noskin2.png"));
[r, c, ch] = size(noskin);
noskin = reshape(noskin, r*c, 3);
    
train_values = [skin; noskin]; % concateniamo i dati di training

rs = size(skin, 1);    % righe skin
rns = size(noskin, 1); % righe noskin

% vettore colonna dove 1 = dati skin, 0 = dati noskin
train_labels = [ones(rs, 1); zeros(rns, 1)];

classifier_cart = fitctree(train_values, train_labels);

save("dataCartStupido.mat", "classifier_cart");