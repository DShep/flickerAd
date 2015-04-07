function bitMap = twoImageInvert60hz(I1,I2,frame)
    % goal of this is to present one image with an hidden image over it

    % make sure the two images are the same size
    if ~all(size(I1)==size(I2))
        disp('the two images should be the same size');
        exit;
    end
    
    if mod(frame,2) == 0
        bitMap = repmat(I1+I2,[1 1 3]);
    else
        bitMap = repmat(I1-I2,[1 1 3]);
    end
    
    maxVal = max(max(max(abs(bitMap))));
    % normalize by max value
    bitMap = bitMap/maxVal;
    
    % convert bit map from contrast to 0 to 1
    bitMap = 0.5*(bitMap+1);
    % convert bitmap from 0 to 1 to 0 to 255
    bitMap = 255*bitMap;
end