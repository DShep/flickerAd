function flickerAd
    thisFolder = fileparts(which('flickerAd'));
    matt = imread(fullfile(thisFolder,'matt.jpg'));
    ball = imread(fullfile(thisFolder,'ball.jpg'));
    
    figure;
    subplot(1,2,1);
    imagesc(matt);
    subplot(1,2,2);
    imagesc(ball);
end