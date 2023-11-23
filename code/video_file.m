clear;
close all;
load("classifier_cart_arcobaleno_v2.mat");


vid = VideoReader("Directory\videoinput.mp4");
frame = read(vid, 1);

[frame_width, frame_height, frame_ch] = size(frame);
background = read(vid, 1);
[r, c, ch] = size(background);
r = floor(r/2);
c = floor(c/2);
background = imresize(background, [r, c]);
i = 0;
v = VideoWriter("Video\video.avi", "Motion JPEG AVI");
v.FrameRate = 8;
open(v);

while hasFrame(vid)

    frame = im2double(readFrame(vid));    
    [r, c, ch] = size(frame);
    r = floor(r/2);
    c = floor(c/2);
    frame = imresize(frame, [r, c]);
    
    % Chiamare la funzione per processare il frame
    predictedFinal = processHard(frame, bayes_AV, bayes_YCr);

    mask3 = double(repmat(predictedFinal,[1,1,3]));
    region = im2double(background).*mask3;
  
    maskInv = 1 - predictedFinal;
    mask3_Inv = double(repmat(maskInv, [1, 1, ch]));
    final = im2double(frame).*mask3_Inv;
  
    final = region + final;
    
    imshow(final); 
    writeVideo(v, mat2gray(final));
end

delete(vid);
close(v);