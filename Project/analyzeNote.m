function [ description, note, newTime, ind ] = analyzeNote(note, ext, startTime, lineInterval)
% Analyze an input note and produce its text-form description

% ---- output ----
% -- description -- A 3-D vector having the format (startTime, duration, pitch), each row describing 
%                   one note. The pair is encoded as two decimals in an internal way. 
% -- newTime --     A scalar indicating the timestamp for the next note.

% ---- input ----
% -- note --  An intensity image containing the note.
% -- ext --   The X-coord of the first staff line. This is used to decide
%             the pitch of a note.
% -- startTime -- The timestamp of this note.

%% SETP 0: see if the unit is any of non-used symbols
beat68 = imread('./Templates/beat68.jpg');
ret = matchATemplate(note, beat68, 0.5, lineInterval);
ind = find(ret > 0);
if size(ind, 1) ~= 0;
    description = [-1, -1, -1];
    newTime = startTime;
    ind = 0;
    return;
end

%% STEP 1: see if the note is annotated by sharp/natural/flat symbol.

sharp = imread('./Templates/sharp.jpg');
natural = imread('./Templates/natural.jpg');
flat = imread('./Templates/flat.jpg');
pitchMark = 0;   % 1 for sharp, 2 for natural, 3 for flat

ret = matchATemplate(note, sharp, 0.75, lineInterval);
ind = find(ret > 0);
if size(ind, 1) ~= 0 % found sharp symbol
    [x, y] = ind2sub(size(note), ind);
    note(x:x+size(sharp, 1)-1, y:y+size(sharp, 2)-1) = 0;
    pitchMark = 1;
    display('sharp!');
else
    ret = matchATemplate(note, natural, 0.75, lineInterval);
    ind = find(ret > 0);  
    if size(ind, 1) ~= 0 % found natural symbol
        [x, y] = ind2sub(size(note), ind);
        note(x:x+size(natural, 1)-1, y:y+size(natural, 2)-1) = 0;
        pitchMark = 2;
        display('natural!');
    else
        ret = matchATemplate(note, flat, 0.75, lineInterval);
        ind = find(ret > 0);  
        if size(ind, 1) ~= 0 % found natural symbol
            [x, y] = ind2sub(size(note), ind);
            note(x:x+size(flat, 1)-1, y:y+size(flat, 2)-1) = 0;
            pitchMark = 3;
        end
    end
end

%% STEP 2: see if the note is a quaver/crotchet/semi/minim
solid_head = imread('./Templates/solid_head.jpg');
hollow_head = imread('./Templates/hollow_head.jpg');
%whole = imread('./Templates/whole.jpg');

nonPause = 0;
ret = matchATemplate(note, solid_head, 0.85, lineInterval);
ind = find(ret > 0);
if size(ind, 1) ~= 0 % found solid head
    description = [startTime, 0.25, -1];
    newTime = startTime + 0.25;
    nonPause = 1;
else
    ret = matchATemplate(note, hollow_head, 0.50, lineInterval);
    ind = find(ret > 0);
    if size(ind, 1) ~= 0 % found hollow head
        description = [startTime, 0.5, -1];
        newTime = startTime + 0.5;
        nonPause = 1;
    end
end

step = round(lineInterval/2);
C = ext + 5*lineInterval;
D = C-step;
E = D-step;
F = E-step;
G = F-step;
A = G-step;
B = A-step;
Ch = B-step;
Dh = Ch-step;
Eh = Dh-step;
Fh = Eh-step;
Gh = Fh-step;
Ah = Gh-step;
Bh = Ah-step;
if nonPause == 1 % decide pitch, build description and return
    [x, y] = ind2sub(size(note), ind(1));
    x = x + step;
    if C - step <= x && x <= C + step;
        description(3) = 0;
    elseif D - step <= x && x <= D + step;
        description(3) = 1;
    elseif E - step <= x && x <= E + step;
        description(3) = 2;
    elseif F - step <= x && x <= F + step;
        description(3) = 3;
    elseif G - step <= x && x <= G + step;
        description(3) = 4;
    elseif A - step <= x && x <= A + step;
        description(3) = 5;
    elseif B - step <= x && x <= B + step;
        description(3) = 6;
    elseif Ch - step <= x && x <= Ch + step;
        description(3) = 7;
    elseif Dh - step <= x && x <= Dh + step;
        description(3) = 8;
    elseif Eh - step <= x && x <= Eh + step;
        description(3) = 9;
    elseif Fh - step <= x && x <= Fh + step;
        description(3) = 10;
    elseif Gh - step <= x && x <= Gh + step;
        description(3) = 11;
    elseif Ah - step <= x && x <= Ah + step;
        description(3) = 12;
    elseif Bh - step <= x && x <= Bh + step;
        description(3) = 13;
    end
    
    % adjust pitch
    if pitchMark ~= 0
        if pitchMark == 1
            description(3) = description(3) + 0.5;
        elseif pitchMark == 3
            description(3) = description(3) - 0.5;
        end
    end
  return;
end
%% STEP 3: see if the note is a pause. if yes, determine its duration
semi = imread('./Templates/semi.jpg');
quaver = imread('./Templates/quaver.jpg');
crotchet = imread('./Templates/crotchet.jpg');
pauseMark = 0;  % 2 for quaver, 3 for crotchet, 4 for semi, 5 for minim

ret = matchATemplate(note, quaver, 0.60, lineInterval);
ind = find(ret > 0);
if size(ind, 1) ~= 0 % found quaver pause
    pauseMark = 2;
else
    ret = matchATemplate(note, crotchet, 0.60, lineInterval);
    ind = find(ret > 0);  
    if size(ind, 1) ~= 0 % found crotchet pause
        pauseMark = 3;
    else
        ret = matchATemplate(note, semi, 0.70, lineInterval);
        ind = find(ret > 0);  
        if size(ind, 1) ~= 0 % found semi / minim pause
            %% TODO: determine whether it's semi or minim
            pauseMark = 4;
        end
    end
end

if pauseMark ~= 0 % we have a pause note. build description and return
    if pauseMark == 2
        description = [startTime, 0.125, 128];
        newTime = startTime + 0.125;
    elseif pauseMark == 3
        description = [startTime, 0.25, 128];
        newTime = startTime + 0.25;
    elseif pauseMark == 4
        description = [startTime, 0.5, 128];
        newTime = startTime + 0.5;
    else 
        description = [startTime, 1, 128];
        newTime = startTime + 1;
    end
    return;
else
    description = [-1, -1, -1];
    newTime = startTime;
    return;
end

end

