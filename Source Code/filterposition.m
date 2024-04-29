% Filter potential region based on position by checking centroid within
% selected region in the mask
function idx = filterposition(stats, maskSize)
maskH = maskSize(1);
maskW = maskSize(2);

minHRatio = 0.35; % max height
maxHRatio = 0.95; % min height
minWRatio = 0.20; % min width
maxWRatio = 0.70; % max width

% Calculates the x and y coordinates of the expected position of the license plate
xv = maskW * [minWRatio, maxWRatio, maxWRatio, minWRatio, minWRatio];
yv = maskH * [minHRatio, minHRatio, maxHRatio, maxHRatio, minHRatio];

hold;
plot(xv,yv);

idx = [];
j = 1;
for i = 1:length(stats)
    centroid = stats(i).Centroid;
    plot(centroid(1), centroid(2), 'gx');
    % Determine if centroids fall within the expected position of the license plate
    if inpolygon(centroid(1), centroid(2), xv, yv)
        idx(j) = i;
        j = j + 1;
    end
end

