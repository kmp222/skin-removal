clear all;
close;
% https://www.mathworks.com/help/imaq/videoinput.html?searchHighlight=videoinput&s_tid=srchtitle_videoinput_1
load("classifier_cart_arcobaleno_v2.mat");
% Recuperare il nome del VideoAdaptor del proprio sistema
ainfo=imaqhwinfo;

% Cambiare VideoAdaptorName
vid = videoinput("winvideo");
vid = videoinput("winvideo");
set(vid, 'FramesPerTrigger', Inf);
    set(vid, 'ReturnedColorspace', 'rgb');
    vid.FrameGrabInterval = 8;  % distance between captured frames 
    start(vid);


frame = getsnapshot(vid);

[frame_width, frame_height, frame_ch] = size(frame);
background = getsnapshot(vid);
[r, c, ch] = size(background);
r = floor(r/2);
c = floor(c/2);
background = imresize(background, [r, c]);
i = 0;
v = VideoWriter("Test\test_video.avi", "Motion JPEG AVI");
v.FrameRate = 5;
open(v);


while vid.FramesAcquired <= 200 
    frame = getsnapshot(vid);
    [r, c, ch] = size(frame);
    r = floor(r/2);
    c = floor(c/2);
    frame = imresize(frame, [r, c]);
    % Chiamare la funzione per processare il frame
    predictedFinal = processHard(frame, background, bayes_AV, bayes_YCr); % ipotetica funzione
    mask3 = double(repmat(predictedFinal,[1,1,3]));
    region = im2double(background).*mask3;
  
    maskInv = 1 - predictedFinal;
    mask3_Inv = double(repmat(maskInv, [1, 1, ch]));
    final = im2double(frame).*mask3_Inv;
  
    final = region + final;
    imshow(final); 
%     writeVideo(v, mat2gray(final));
%     writeVideo(v, double(im));
%     i = i+1;
end
% writeVideo(v, mat2gray(processed));
delete(vid);
close(v);