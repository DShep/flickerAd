thisFolder = fileparts(which('flickerAd'));
matt = imread(fullfile(thisFolder,'matt.jpg'));
ball = imread(fullfile(thisFolder,'ball.jpg'));

matt = (double(rgb2gray(matt))-128)/128;
ball = (double(rgb2gray(ball))-128)/128;

matt = imresize(matt,1/4);

keyQ = 81;

% if necessary initialize the DLP
%     flickerDLP;

%     filterX = normpdf(-10:10,0,4);
%     filterY = normpdf(-10:10,0,4)';
%     filter = filterY*filterX;
%     matt = conv2(matt,filter,'same');
wID = Screen('OpenWindow',2);
flipT = GetSecs();
playMovie = 1;
frame = 0;

numFrames = 60;
timeToFlip = zeros(numFrames,1);
frameStart = 0;


bitMap = zeros([size(matt) 3]);

%     for ff = 1:numFrames
while playMovie
    frameStart = GetSecs();
    frame = frame + 1;

    if mod(frame,2) == 0
        bitMap(:,:,1) = matt;
        bitMap(:,:,2) = -matt;
        bitMap(:,:,3) = matt;
    else
        bitMap(:,:,1) = -matt;
        bitMap(:,:,2) = matt;
        bitMap(:,:,3) = -matt;
    end

    % find max value
    maxVal = max(max(max(abs(bitMap))));
    % normalize by max value
    bitMap = bsxfun(@rdivide,bitMap,maxVal);

    % convert bit map from contrast to 0 to 1
    bitMap = 2/3*0.5*(bitMap+1);
    % convert bitmap from 0 to 1 to 0 to 255
    bitMap = 255*bitMap;

    wTex = Screen('MakeTexture', wID, bitMap);
    Screen('DrawTexture',wID,wTex,[],[],[],0);
    flipT = Screen('Flip',wID,flipT+1/120);

    [~,~,keyList]=KbCheck; % check this once
    if keyList(keyQ)
        playMovie = 0;
        sca;
    end

    if mod(frame,60) == 0
        disp(['frame # ' num2str(frame)]);
    end

    timeToFlip(frame) = GetSecs()-frameStart;
end