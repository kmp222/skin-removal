function frameGrayWorld = awb_frame_grayWorld(frame)
    frame = rgb2lin(frame);
    illuminantGrayWorld = illumgray(frame, 0.5);
    linGrayWorld = chromadapt(frame , illuminantGrayWorld, 'ColorSpace', 'linear-rgb');
    frameGrayWorld = lin2rgb(linGrayWorld);
end

