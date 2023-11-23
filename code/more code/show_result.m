% Mostra i pixel dell'immagine corrispondenti alla maschera binaria
% image immagine di input
% mask maschera binaria dell'immagine
function show_result(image, mask, title_image)
  
  [r,c,ch] = size(image);
    
  %mask = 1 - mask;
  mask3 = double(repmat(mask,[1,1,ch]));
  region = im2double(image).*mask3;
  
  figure;
  subplot(1, 2, 1), imshow(image), title("Iniziale");
  subplot(1, 2, 2), imshow(region), title(title_image);

end
