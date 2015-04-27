thisFolder = fileparts(which('flickerAd'));
I1 = imread(fullfile(thisFolder,'matt.jpg'));
I2 = imread(fullfile(thisFolder,'stop.png'));

I1 = (double(rgb2gray(I1))-128)/128;
I2 = (double(rgb2gray(I2))-128)/128;

sizeY = 400;
sizeX = 400;

I1 = imresize(I1,[sizeY sizeX],'nearest');
I2 = imresize(I2,[sizeY sizeX],'nearest');

flickerDLP('bitDepth',7);

keyQ = 81;

wID = Screen('OpenWindow',2);
flipT = GetSecs();
playMovie = 1;
frame = 0;

numFrames = 10000;
timeToFlip = zeros(numFrames,1);
frameStart = 0;


while playMovie
    frameStart = GetSecs();
    frame = frame + 1;
%     bitMap = twoImageStim(I1,I2,50,frame);
    bitMap = twoImageInvert60hz(I1,I2,frame);
%     bitMap = twoImageInvert120hz(I1,I2);
%     bitMap = twoImageInvert180hz(I1,I2,frame);
%     bitMap = ABnegB(I1,I2);
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
end

timeToFlip = timeToFlip(timeToFlip>0);