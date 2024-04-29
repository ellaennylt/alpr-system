% Filter potential region based on expected area/size
function idx = filterarea(stats, maskSize)
maskH = maskSize(1);
maskW = maskSize(2);

aRatio = 0.50; % area
wRatio = 0.75; % width
hRatio = 0.65; % height

maxA = maskW * maskH * aRatio;
maxW = maskW * wRatio;
maxH = maskH * hRatio;


% Filter region based on their area, width, and height using bounding box information
idx = [];
j = 1;
for i = 1:length(stats)
    boundingBox = stats(i).BoundingBox;
    area = prod(boundingBox(3:4));
    if area > 500 && all(boundingBox(3:4) > [30, 10]) && area < maxA &&...
            all(boundingBox(3:4) < [maxW, maxH])
        idx(j) = i;
        j = j + 1;
    end
end

