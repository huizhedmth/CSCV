function [img] = binarize(I, threshold)
% binarize the input image according to specified threshold

% determine whether it is a RGB image
if size(I, 3) == 3
    % convert to grayscale
    gI = rgb2gray(I);
    gI(gI > threshold) = 255;
    gI(gI <= threshold) = 0;

    img = gI;
else
    img = I;
end

end

