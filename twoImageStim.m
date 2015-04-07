function bitMap = twoImageStim(I1,I2,alpha)
    % psychophysically this does't seem to work :(

    % the goal of this function is to create a bitmap such that when two
    % images A and B are summed they create I1, and if they are summed
    % while B is shifted by alpha they create I2.
    % Formally
    % A(y,x) + B(y,x) = I1
    % A(y,x) + B(y,x-alpha) = I2
    
    % rearrange
    % B(y,x) = I1(y,x) - I2(y,x) + B(y,x-alpha)
    % A(y,x) = I1(y,x) - B(y,x)
    
    % thus we can derive what A and B should be given the inputs I1, I2,
    % and alpha
    
    % Because B is finite, the first alpha entries are arbitrary because
    % B(y,negative) is undefined. I will call this the seed of B. Once the
    % seed is determined, starting at B(y,alpha+1) loop through the
    % diffImage I1 - I2 and sum it with B(y,currColumn - alpha)
    
    % You can then see that any given value of B is a function not just of
    % the diffImage at that column, but every previous value of B in steps
    % of alpha.
    % Formally where R is the right shift opperator such that
    % R^alpha*f(x) = f(x-alpha)
    % B(y,x) = (1 + R^alpha + R^2*alpha + R^3*alpha ...)*diffImage(y,x);
    % B(y,x) = sum(R^ii*alpha,ii,0,floor(x/alpha))*diffImage(y,x);
    
    % Thus the rightward most values of B(y,x) can potentially become vary
    % large as they are the sum of all previous values. The best possible
    % seed then, is the opposite signed maximum pixel value. This insures
    % that sum(R^ii*alpha,ii,0,floor(x/alpha)) has the property abs(min) =
    % abs(max) and thus maximizes the contrast of the image.
    % note: this maximizes the contrast of the image because the projector
    % has limited contrast range. The more you use of this range the higher
    % the contrast

    % make sure the two images are the same size
    if ~all(size(I1)==size(I2))
        disp('the two images should be the same size');
        exit;
    end
    
    % initialize seed, B, and diffImage
    seed = zeros(size(I1,1),alpha);
    B = zeros(size(I1));
    diffImage = I1-I2;
    
    % create the seed by looping throught he first alpha values. Find the
    % maximum pixel and set the seed value to -1/2 that value.
    for aa = 1:alpha
        linkedVals = diffImage(:,alpha+aa:alpha:size(I1,2));
        predictedPix = cumsum(linkedVals,2);
        [maxPixel,maxLoc] = max(abs(predictedPix),[],2);
        seed(:,aa) = -1/2*sign(predictedPix(maxLoc)).*maxPixel;
    end
    
    % make the first alpha values of B equal to the seed
    B(:,1:alpha) = seed;
    
    % create B
    for cc = alpha+1:size(I1,2)
        B(:,cc) = diffImage(:,cc) + B(:,cc-alpha);
    end
    
    % create A
    A = I1 - B;
    
    % initialize bitMap
    bitMap = zeros([size(I1) 3]);
    bitMap(:,:,1) = A;
    bitMap(:,:,2) = B;
    
    % the projector has a limited contrast so make sure you don't clip.
    % Potentially consider clipping if there are a small number of pixels
    % that are absurdly bright to keep from dividing by a large number and
    % lowering contrast
    % find max value
    maxVal = max(max(max(abs(bitMap))));
    % normalize by max value
    bitMap = bitMap/maxVal;
    
    % create two spots for the viewer to look at, exactly alpha apart
    tX = round((size(I1,2)-alpha)/2);
    tY = round(size(I1,1)/3);
    
    tSizeX = 5;
    tSizeY = 5;
    
    % create first target
    bitMap(tY:tY+tSizeY,tX:tX+tSizeX,:) = -1;
    % create the second target
    bitMap(tY:tY+tSizeY,tX+alpha-1:tX+tSizeX+alpha-1,:) = -1;
    
    % convert bit map from contrast to 0 to 1
    bitMap = 0.5*(bitMap+1);
    % convert bitmap from 0 to 1 to 0 to 255
    bitMap = 255*bitMap;
end