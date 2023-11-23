function imfSharpen = sharpen_frame(im)
    imfSharpen = imsharpen(im, "amount", 1.0);
end
