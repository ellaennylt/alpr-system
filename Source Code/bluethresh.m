% Extract blue based on HSV threshold
function blueMask = bluethresh(hsvI)

% Define blue thresholds for hue, saturation and value channels
hueThreshMin = 0.500;
hueThreshMax = 0.700;
satThreshMin = 0.500;
satThreshMax = 1.000;
valThreshMin = 0.500;
valThreshMax = 1.000;

% Create mask based on chosen thresholds
if hueThreshMin > hueThreshMax
    blueMask = ((hsvI(:,:,1) >= hueThreshMin) | (hsvI(:,:,1) <= hueThreshMax)) & ...
        (hsvI(:,:,2) >= satThreshMin) & (hsvI(:,:,2) <= satThreshMax) & ...
        (hsvI(:,:,3) >= valThreshMin) & (hsvI(:,:,3) <= valThreshMax);
else
    blueMask = ((hsvI(:,:,1) >= hueThreshMin) & (hsvI(:,:,1) <= hueThreshMax)) & ...
        (hsvI(:,:,2) >= satThreshMin) & (hsvI(:,:,2) <= satThreshMax) & ...
        (hsvI(:,:,3) >= valThreshMin) & (hsvI(:,:,3) <= valThreshMax);
end

% Remove blobs smaller than 25 px
blueMask = bwareaopen(blueMask, 25);

