thisFolder = fileparts(which('flickerAd'));
matt = imread(fullfile(thisFolder,'matt.jpg'));
ball = imread(fullfile(thisFolder,'ball.jpg'));

matt = (double(rgb2gray(matt))-128)/128;
ball = (double(rgb2gray(ball))-128)/128;

sizeY = 400;
sizeX = 400;

matt = imresize(matt,[sizeY sizeX],'nearest');
ball = imresize(ball,[sizeY sizeX],'nearest');

keyQ = 81;

% wID = Screen('OpenWindow',2);
flipT = GetSecs();
playMovie = 1;
frame = 0;

numFrames = 10000;
timeToFlip = zeros(numFrames,1);
frameStart = 0;


bitMap = twoImageStim(matt,ball,20);

while playMovie
    frameStart = GetSecs();
    frame = frame + 1;


    wTex = Screen('MakeTexture', wID, bitMap);
    Screen('DrawTexture',wID,wTex,[],[0 0 608 684],[],0);
    flipT = Screen('Flip',wID,flipT+1/120);
    Screen('Close',wTex);

    [~,~,keyList]=KbCheck; % check this once
    if keyList(keyQ)
        playMovie = 0;
        sca;
    end

    if mod(frame,60) == 0
        disp(['frame # ' num2str(frame)]);
    end
    
    % measure how long it takes to flip but, make sure we don't go over the
    % size of the array and slow the program down
    if timeToFlip <= numFrames
        timeToFlip(frame) = GetSecs()-frameStart;
    end
end

timeToFlip = timeToFlip(timeToFlip>0);