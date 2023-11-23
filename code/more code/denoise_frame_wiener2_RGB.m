function wienerFrame = denoise_frame_wiener2_RGB(frame, n)
    R = frame(:, :, 1);
    G = frame(:, :, 2);
    B = frame(:, :, 3);
    
    Rw = wiener2(R, [n, n]);
    Gw = wiener2(G, [n, n]);
    Bw = wiener2(B, [n, n]);
    wienerFrame = cat(3, Rw, Gw, Bw);
end