% https://www.mathworks.com/help/imaq/videoinput.html?searchHighlight=videoinput&s_tid=srchtitle_videoinput_1
load("model.mat");
load("quadratic_model.mat");
% Recuperare il nome del VideoAdaptor del proprio sistema

image = imread("test1.jpg");
ainfo=imaqhwinfo;

% Cambiare VideoAdaptorName
vid = videoinput("winvideo");
set(vid, 'FramesPerTrigger', Inf);
set(vid, 'ReturnedColorspace', 'rgb');
vid.FrameGrabInterval = 5;  % distance between captured frames 
start(vid) 

%preview(vid);

frame = getsnapshot(vid);

[frame_width, frame_height, frame_ch] = size(frame);

initial_frame = frame;
new_frame = 0;

while vid.FramesAcquired<=600
    %frame = getsnapshot(vid);
    
    % Chiamare la funzione per processare il frame
    new_frame = process_frame(getsnapshot(vid), initial_frame, trainedModel);
    imshow(new_frame);
end

delete(vid);