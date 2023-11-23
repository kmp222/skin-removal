function finalFframe = pre_processingAWB(frame)
    noiseLevel = estimate_noise(rgb2gray(frame));
    fprintf("\nLevel Noise = %f\n", noiseLevel);
    [r, c, ch] = size(frame);

    if noiseLevel < 0.30 || max([r, c]) > 700
        awb = awb_frame_grayWorld(frame);
        finalFframe = imadjust_contrast(awb);
    else 
        n = 3;
        if noiseLevel > 0.7 && noiseLevel < 0.9
            n = 3;
        elseif noiseLevel > 0.9
            n = 3;
        end

        denoise = denoise_frame_wiener2_RGB(frame, n);
        awb = awb_frame_grayWorld(denoise);
        finalFframe = imadjust_contrast(awb);
    end
        
end