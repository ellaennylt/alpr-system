% Extract yellow based on HSV threshold
function yellowMask = yellowthresh(hsvI)

% Define yellow thresholds for hue, saturation and value channels
hueThreshMin = 0.100;
hueThreshMax = 0.200;
satThreshMin = 0.550;
satThreshMax = 1.000;
valThreshMin = 0.550;
valThreshMax = 1.000;

% Create mask based on chosen thresholds
if hueThreshMin > hueThreshMax
    yellowMask = ((hsvI(:,:,1) >= hueThreshMin) | (hsvI(:,:,1) <= hueThreshMax)) & ...
        (hsvI(:,:,2) >= satThreshMin) & (hsvI(:,:,2) <= satThreshMax) & ...
        (hsvI(:,:,3) >= valThreshMin) & (hsvI(:,:,3) <= valThreshMax);
else
    yellowMask = ((hsvI(:,:,1) >= hueThreshMin) & (hsvI(:,:,1) <= hueThreshMax)) & ...
        (hsvI(:,:,2) >= satThreshMin) & (hsvI(:,:,2) <= satThreshMax) & ...
        (hsvI(:,:,3) >= valThreshMin) & (hsvI(:,:,3) <= valThreshMax);
end

% Remove blobs smaller than 25 px
yellowMask = bwareaopen(yellowMask, 25);

