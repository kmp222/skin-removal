function propagated_mask = propagate(mask, otsu, r, c)
grey = (mask == 0.5);
s = strel("disk", 19);
se = strel("disk", 35);
grey = imclose(grey, se);

grey = grey(:);
mask = imclose(mask, s);  
tmpmask = mask(:);
tmpimg = otsu(:);
for k = 1:length(mask(:))
    if(tmpmask(k) ~=1  && tmpimg(k) == 1 && grey(k) == 1)
        tmpmask(k) = 1;
    end
end
    propagated_mask = reshape(tmpmask, r,c);
    propagated_mask = (propagated_mask == 1);
    propagated_mask = bwareaopen(propagated_mask, 1000);
     figure(2), imshow(propagated_mask);
end





