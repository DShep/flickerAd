thisFolder = fileparts(which('flickerAd'));


Screen('Preference', 'SkipSyncTests', 1);

keyQ = 81;
keyRight = 39;
keyLeft = 37;
keySpace = 32;

wID = Screen('OpenWindow',2);
flipT = GetSecs();
playMovie = 1;
frame = 0;

numFrames = 10000;
timeToFlip = zeros(numFrames,1);
frameStart = 0;

stimCount = 0;
plotTracer = 0;
initialized = 0;

% initialize tracer values
tracerDist = 100;
tracerMean = 200;
tracerFreq = 45;
tracerX = 200;
tracerSizeX = 10;
tracerSizeY = 10;
tracerY = 300;

while playMovie
    frameStart = GetSecs();
    frame = frame + 1;
    
    switch stimCount
        case 0
            if ~initialized
                I1 = imread(fullfile(thisFolder,'gray.jpg'));
                I2 = imread(fullfile(thisFolder,'yale.jpg'));

                [I1,I2] = NormImage(I1,I2);
            
                flickerDLP('bitDepth',7);
                initialized = 1;
            end
            
            bitMap = ABnegB(I1,I2);
        
        case 1
            if ~initialized
                I1 = imread(fullfile(thisFolder,'yaleSML.jpg'));
                I2 = imread(fullfile(thisFolder,'yale.jpg'));

                [I1,I2] = NormImage(I1,I2);
             
                flickerDLP('bitDepth',7);
                initialized = 1;
            end
            
            bitMap = ABnegB(I1,I2);
            
        case 2
            if ~initialized
                I1 = imread(fullfile(thisFolder,'yaleSML.jpg'));
                I2 = imread(fullfile(thisFolder,'yale.jpg'));

                [I1,I2] = NormImage(I1,I2);

                flickerDLP('bitDepth',7);
                initialized = 1;
            end
            
            I1 = circshift(I1,[0 1]);
            bitMap = ABnegB(I1,I2);
            
        case 3
            if ~initialized
                I1 = imread(fullfile(thisFolder,'yaleSML.jpg'));
                I2 = imread(fullfile(thisFolder,'yale.jpg'));

                [I1,I2] = NormImage(I1,I2);

                flickerDLP('bitDepth',7);
                initialized = 1;
            end
            
            I2 = circshift(I2,[0 -1]);
            bitMap = ABnegB(I1,I2);
    end
    
    if plotTracer
        tracerX = round(tracerDist*sin(2*pi*frame/tracerFreq)+tracerMean);
        bitMap(tracerY:tracerY+tracerSizeY,tracerX:tracerX+tracerSizeX) = 0;
    end
    
    wTex = flickMakeTexture(bitMap,wID);

    Screen('DrawTexture',wID,wTex,[],[0 0 608 684],[],0);
    flipT = Screen('Flip',wID,flipT+1/120);
    Screen('Close',wTex);
    
    if mod(frame,60) == 0
        disp(['frame # ' num2str(frame)]);
    end
    
    % measure how long it takes to flip but, make sure we don't go over the
    % size of the array and slow the program down
    if timeToFlip <= numFrames
        timeToFlip(frame) = GetSecs()-frameStart;
    end
    
    [~,~,keyList]=KbCheck; % check this once
    if keyList(keyQ)
        playMovie = 0;
        sca;
    end
    
    if keyList(keyRight)
        stimCount = stimCount + 1;
        initialized = 0;
        
        while keyList(keyRight)
            [~,~,keyList]=KbCheck;
        end
    end
    
    if keyList(keyLeft)
        stimCount = stimCount - 1;
        initialized = 0;
        
        while keyList(keyLeft)
            [~,~,keyList]=KbCheck;
        end
    end
    
    if keyList(keySpace)
        plotTracer = ~plotTracer;
        
        while keyList(keySpace)
            [~,~,keyList]=KbCheck;
        end
    end
    
    stimCount = mod(stimCount,4);
end

timeToFlip = timeToFlip(timeToFlip>0);


