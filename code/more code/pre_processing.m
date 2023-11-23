function finalFframe = pre_processing(frame)
    noiseLevel = estimate_noise(rgb2gray(frame));
    
    [r, c, ch] = size(frame);

    if noiseLevel < 0.30 || max([r, c]) > 900
        finalFframe = imadjust_contrast(frame);
    else 
        n = 5;

        if noiseLevel > 0.7 && noiseLevel < 0.9
            n = 7;
        elseif noiseLevel > 0.9
            n = 9;
        end

        denoise = denoise_frame_wiener2_RGB(frame, n);
        finalFframe = imadjust_contrast(denoise);
        estimate_noise(rgb2gray(finalFframe));
    end
end