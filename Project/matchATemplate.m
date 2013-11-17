function [ret] = matchATemplate(I, template, threshold, lineInterval)

% note: I and template are supposed to be grayscale image.
img = I;
pattern = imresize(template, lineInterval/6);
mT = size(pattern, 1);
nT = size(pattern, 2);
m = size(I, 1);
n = size(I, 2);

output = normxcorr2(pattern, img);
ret = output(mT:end, nT:end);
ret(ret < threshold) = 0;

% non-maximal suppression
padding = 15;
pI = zeros(2*15+m, 2*15+n);
pI(padding+1:padding+m, padding+1:padding+n) = ret;

for x = padding+1:padding+m
    for y = padding+1:padding+n
        maxCorr = max(max(pI(x-padding:x+padding, y-padding:y+padding)));
        if maxCorr ~= pI(x, y)
            pI(x, y) = 0;
        end
    end
end

dil = pI;

for x = padding+1:padding+m
    for y = padding+1:padding+n
        if pI(x, y) ~= 0
            dil(x-2:x+2, y-2:y+2) = pI(x, y);
        end
    end
end

ret = dil(padding+1:padding+m, padding+1:padding+n);