function [ notes, V ] = segNote(fragments, lineInterval)
% segment out notes in each fragment
%
% ---- output ----
% -- notes -- A 3-D matrix containing image fragment for each note
%
% ---- input ----
% -- fragments -- A 3-D matrix containing fragments of the music sheet

noFragments = size(fragments, 3);

ind = 1;
% hyper params
excerptLenL = round(2.5*lineInterval);
excerptLenR = round(1.4*lineInterval);

noNotes = 0;
notes = zeros(size(fragments(:, :, 1), 1), excerptLenL + excerptLenR + 1, 300);

for frag = 7:7 % noFragments % for each fragment
    fragment = 255 - fragments(:, :, frag);
    
    V = intProj(fragment, 'v');
    int = V(2, :);
    
    localMaxLoc = zeros(1, size(fragment, 2));
    
    % hyper params
    len = 10;
    minAccPxl = 2;
    
    % eliminate section lines from both intensity map and original image
    secSegThreshold = 0.9*max(int);
    secLines = find(int > secSegThreshold);
    int(secLines) = (minAccPxl-1)*255;  % from intensity map
    startPoint = min(secLines);
    endPoint = max(secLines) - 5;
    %fragment(:, secLines) = 0; % from image
    
    % find notes
    cnt = 1;
    for i = startPoint:endPoint
        if max(max(int(i-len:i+len))) == int(i) && int(i) > minAccPxl*255
            localMaxLoc(cnt) = i;
            int(i) = int(i) + 1; % avoid replicates
            cnt = cnt + 1;
        end
    end
    localMaxLoc = localMaxLoc(localMaxLoc > 0);
    
    s = size(localMaxLoc, 2);
    noNotes = noNotes + s;

    
    temp = zeros(size(fragment, 1), excerptLenL + excerptLenR + 1, s);   
    % build excerpts where a note may lie
    for i = 1:s
        temp(:, :, i) = fragment(:, localMaxLoc(i)-excerptLenL:localMaxLoc(i)+excerptLenR);
    end
    notes(:, :, ind:ind+s-1) = temp(:, :, 1:s);
    ind = ind+s;
end
notes = notes(:, :, 1:noNotes);