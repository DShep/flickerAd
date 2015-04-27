function bitMap = twoImageInvert180hz(I1,I2,frame)
    % goal of this is to present one image with an hidden image over it
    % make sure the two images are the same size
    if ~all(size(I1)==size(I2))
        disp('the two images should be the same size');
        exit;
    end
    
    bitMap = zeros(size(I1,1),size(I1,2),3);
    
    if mod(frame,2) == 0
        bitMap(:,:,1) = I1+I2;
        bitMap(:,:,2) = I1-I2;
        bitMap(:,:,3) = I1+I2;
    else
        bitMap(:,:,1) = I1-I2;
        bitMap(:,:,2) = I1+I2;
        bitMap(:,:,3) = I1-I2;
    end
    maxVal = max(max(max(abs(bitMap))));
    % normalize by max value
    bitMap = bitMap./maxVal;
    
    % convert bit map from contrast to 0 to 1
    bitMap = 0.5*(bitMap+1);
end