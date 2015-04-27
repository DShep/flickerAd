function tex = flickMakeTexture(bitMap,windowID)
    bitMap = bitMap*255;
    
    bitMap = bitMap(:,:,[2 3 1]);
    
    tex = Screen('MakeTexture', windowID, bitMap);
end