% Mostra i pixel dell'immagine corrispondenti alla maschera binaria
% image immagine di input
% mask maschera binaria dell'immagine
function show_result(image, mask, background)
  
  [r,c,ch] = size(image);
    
  %mask = 1 - mask;
  mask3 = double(repmat(mask,[1,1,ch]));
  region = im2double(background).*mask3;
  
  maskInv = 1 - mask;
  mask3_Inv = double(repmat(maskInv, [1, 1, ch]));
  final = im2double(image).*mask3_Inv;
  
  finale = region + final;

  figure;
  subplot(1, 2, 1), imshow(image), title("Pre-Processata");
  subplot(1, 2, 2), imshow(finale), title("Finale");
  

end
