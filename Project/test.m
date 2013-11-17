close all;clc; clear;

filename = './Dataset/music25.jpg';
img = imread(filename);

% binarize
img = binarize(img, 128);

% perform intensity projection along horizontal axis
H = intProj(img, 'h');
int = H(2, :);

% find coordinates where staff lines are located
staff = findStaff(int, img);
lineInterval = staff(2) - staff(1);

% remove staff lines from image, and group music notes by line
[fragments, nsImg, ext] = grp(img, staff);

% segment out notes in each fragment
[notes, V] = segNote(fragments, lineInterval);

% analyze notes one by one
startTime = 0;
fid = fopen('notes1', 'w+');
for i = 1:size(notes, 3)
    [des, notes(:, :, i), startTime, ind] = analyzeNote(notes(:, :, i), ext, startTime, lineInterval);
    display(des);
    fprintf(fid, '%f,%f,%f\n', des);
end
fclose(fid);

semi = imread('./Templates/semi.jpg');
quaver = imread('./Templates/quaver.jpg');
crotchet = imread('./Templates/crotchet.jpg');

showNotes = 1;
showMusic = 0;

%% figures
figureCnt = 1;

% figure(figureCnt); figureCnt = figureCnt + 1;
% imshow(img);
% title('Binarized image');


% figure(figureCnt); figureCnt = figureCnt + 1;
% plot(H(1,:), H(2,:));
% title('Intensity projection along horizontal line');


if showMusic == 1
    figure(figureCnt); figureCnt = figureCnt + 1;
    imshow(nsImg);
    title('Staff lines removed');
end

% 
% for i = 1:1 %size(fragments, 3)
%     figure(figureCnt); figureCnt = figureCnt + 1;
%     imshow(fragments(:, :, i));
%     title('One fragment');
%     figure(figureCnt); figureCnt = figureCnt + 1;
%     V = intProj(fragments(:, :, i), 'v');
%     plot(V(1, :), V(2, :));
%     title('Intensity projection along vertical line');
% end
% 
%    figure(figureCnt); figureCnt = figureCnt + 1;
%    plot(V(1, :), V(2, :));
%    axis([100, 250, -100, 14000]);
%    title('Intensity projection along vertical line');
%      
%   
% 
%    figure(figureCnt); figureCnt = figureCnt + 1;
%    plot(V(1, :), V(2, :));
%    axis([100, 250, -100, 14000]);
%    title('Intensity projection along vertical line');
%      
% 
%    figure(figureCnt); figureCnt = figureCnt + 1;
%    plot(V(1, :), V(2, :));
%    axis([230, 380, -100, 14000]);
%    title('Intensity projection along vertical line');
%      
% 
%    figure(figureCnt); figureCnt = figureCnt + 1;
%    plot(V(1, :), V(2, :));
%    axis([360, 520, -100, 14000]);
%    title('Intensity projection along vertical line');
%      
%    figure(figureCnt); figureCnt = figureCnt + 1;
%    plot(V(1, :), V(2, :));
%    axis([500, 650, -100, 14000]);
%    title('Intensity projection along vertical line');

if showNotes == 1
    thresh = 0.75;
    template = imread('./Templates/flat.jpg');
    for i = 1:size(notes, 3)
        figure(figureCnt); figureCnt = figureCnt + 1;
        imshow(notes(:, :, i));
        title('One note');
%         H = intProj(notes(:, :, i), 'h');
%         figure(figureCnt); figureCnt = figureCnt + 1;
%         plot(H(1, :), H(2, :));
%         title('horizontal projection');       
    end
end