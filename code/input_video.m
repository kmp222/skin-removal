clear all;
close all;

vid = VideoReader('video_test.mp4');
depvideoPlayer = vision.DeployableVideoPlayer;

numFrames = vid.NumFrames;
background = read(vid, 1); % scegliere n-esimo frame

for iFrame = 1:numFrames
    frame = read(vid, iFrame);
    frame = process_frame_two(frame, background); % ipotetica funzione
    depvideoPlayer(frame);  
end



