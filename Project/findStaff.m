function [ staff ] = findStaff(int, I)
% find locations of staff lines according to given map of intensity
% projection.

thresh = 2.*min(int);

staff = zeros(1, size(int, 2));
cnt = 1;
for i = 5:size(int, 2)-4
    if int(i) < thresh % && int(i) == min(int(i-4:i+4))
        staff(cnt) = i;
        cnt = cnt+1;
        int(i) = i-1; % avoid replicates
    end
end

staff = staff(staff > 0);

% % elimenate duplicates
% for i = 2:size(staff, 2)-1
%     if staff(i) - staff(i-1) < 2 || staff(i+1) - staff(i) < 2
%         staff(i) = 0;
%         I(i, :) = 255;
%     end
% end
% staff = staff(staff > 0);

end

