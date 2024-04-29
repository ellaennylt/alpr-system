% Extract red based on HSV threshold
function redMask = redthresh(hsvI)

% Define red maximum and minimum thresholds for hue, saturation and value channels
hueThreshMin = 0.865;
hueThreshMax = 0.075;
satThreshMin = 0.200;
satThreshMax = 1.000;
valThreshMin = 0.300;
valThreshMax = 1.000;

% Create mask based on chosen thresholds
if hueThreshMin > hueThreshMax
    redMask = ((hsvI(:,:,1) >= hueThreshMin) | (hsvI(:,:,1) <= hueThreshMax)) & ...
        (hsvI(:,:,2) >= satThreshMin) & (hsvI(:,:,2) <= satThreshMax) & ...
        (hsvI(:,:,3) >= valThreshMin) & (hsvI(:,:,3) <= valThreshMax);
else
    redMask = ((hsvI(:,:,1) >= hueThreshMin) & (hsvI(:,:,1) <= hueThreshMax)) & ...
        (hsvI(:,:,2) >= satThreshMin) & (hsvI(:,:,2) <= satThreshMax) & ...
        (hsvI(:,:,3) >= valThreshMin) & (hsvI(:,:,3) <= valThreshMax);
end

% Remove blobs smaller than 25 px
redMask = bwareaopen(redMask, 25);

