function [ret, nsImg, ext] = grp(img, X)

% Remove staff lines from the input image, and group notes per line.
% ---- output ----
% -- ret -- A 3-D matrix containing fragments of the music, each being one
%           line in the music sheet.
% -- ext -- A parameter used to segment fragments.
%
% ---- input ----
% -- X -- A vector that contains coordinates where staff lines are located.

s2 = size(img, 2);

% number of staff lines
noLines = size(X,2);

% fine lines form a group
noGrps = noLines/5;

%% remove staff lines
rmvThreshold_sq = 16;
rmvThreshold_v = 3;

nsImg = img;
for grp = 1:noGrps    % for each group of lines
    for line = 1:5    % for each line in that group (may contain extra lines)
        center = int32(X(5*(grp-1)+line));
        for loc = center;    % coordinate of this line
            for i = 3:s2-2  % for each pixel on this staff line
                % A pixel is removed only if there are no other notations around
                % it. This ensures that meaningful signs and symbols are
                % preserved.
                % current pixel: (loc, i)
                mark = 0;
                tmp = sum(sum(img(loc-2:loc+2, i-2:i+2)==0));
                if tmp < rmvThreshold_sq
                    mark = mark + 1;
                end
                tmp = sum(img(loc-2:loc+2, i)==0);
                if tmp < rmvThreshold_v
                    mark = mark + 1;
                end
                if mark == 2
                    nsImg(loc, i) = 255;
                end
            end
        end
    end
end


%% group notes by line
if noLines > 5
    ext = int32((X(6) - X(5))*0.3);
else
    ext = X(2) - X(1);
end

fragHeight = int32(X(5) - X(1) + 2*ext);
ret = zeros(fragHeight, s2, noGrps);

for i = 1:noGrps
    start = X(5*(i-1)+1) - ext;
    ret(:, :, i) = nsImg(start:start+fragHeight-1 , :);
end
ret = uint8(ret);

end

