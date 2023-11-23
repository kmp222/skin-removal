function adjustFrame = imadjust_contrast(frame)
    frameDouble = im2double(frame);
    
    % calculate average and standard deviation
    average = mean2(frameDouble);
    sigma = std2(frameDouble);
    n = 2;  
    low = average-n*sigma;

    % c'è il rischio di fininire fuori da [0, 1]
    if (low) < 0
        low = 0;
    end
    
    high = average+n*sigma;
    if (high) > 1
        high = 1;
    end
    
    adjustFrame = imadjust(frameDouble,[low high], []);
end