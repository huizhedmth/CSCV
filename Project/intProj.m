function [projection] = intProj(I, direction)
% Project intensities of the input image I along the specified direction

% ---- output ----
% A 2xN matrix, where the first dimension corresponds to coordinates the
% other direction (not the one specified by the second argument)
% and the second dimension the intensity accumulation 
% on each coordinate.

% ---- input ----
% -- I -- The input grayscale image.
% -- direction -- Can be 'v' or 'h', specifying the direction along which
%    intensities are projected.

% get the length of the axis onto which intensities are projected
if direction == 'v'
    length = size(I, 2);
else
    length = size(I, 1);
end

% allocate memory for return matrix
projection = zeros(2, length);

% fill coordinates
projection(1, :) = 1:length;

% fill accumulations of intensity at each coordinates.
if direction == 'v'
    projection(2, :) = sum(I);
else
    projection(2, :) = sum(I, 2);
end

end

