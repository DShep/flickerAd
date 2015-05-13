function [out1,out2] = NormImage(in1,in2)
    middle1 = (double(rgb2gray(in1))-128)/128;
    middle2 = (double(rgb2gray(in2))-128)/128;

    sizeY = 400;
    sizeX = 400;

    out1 = imresize(middle1,[sizeY sizeX],'nearest');
    out2 = imresize(middle2,[sizeY sizeX],'nearest');
end