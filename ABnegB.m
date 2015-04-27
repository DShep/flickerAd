function bitMap = twoImageInvert(I1,I2)
    % goal of this is to present one image with an hidden image over it

    % make sure the two images are the same size
    if ~all(size(I1)==size(I2))
        disp('the two images should be the same size');
        exit;
    end
    
    bitMap = zeros([size(I1) 3]);
    bitMap(:,:,1) = I1;
    bitMap(:,:,2) = I2;
    bitMap(:,:,3) = -I2;
    
    % find max value
    maxVal = max(max(max(abs(bitMap))));
    % normalize by max value
    bitMap = bitMap/maxVal;
    
    % convert bit map from contrast to 0 to 1
    bitMap = 0.5*(bitMap+1);
end