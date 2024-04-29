% Extract green based on HSV threshold
function greenMask = greenthresh(hsvI)

% Define green thresholds for hue, saturation and value channels
hueThreshMin = 0.275;
hueThreshMax = 0.550;
satThreshMin = 0.500;
satThreshMax = 1.000;
valThreshMin = 0.250;
valThreshMax = 1.000;

% Create mask based on chosen thresholds
if hueThreshMin > hueThreshMax
    greenMask = ((hsvI(:,:,1) >= hueThreshMin) | (hsvI(:,:,1) <= hueThreshMax)) & ...
        (hsvI(:,:,2) >= satThreshMin) & (hsvI(:,:,2) <= satThreshMax) & ...
        (hsvI(:,:,3) >= valThreshMin) & (hsvI(:,:,3) <= valThreshMax);
else
    greenMask = ((hsvI(:,:,1) >= hueThreshMin) & (hsvI(:,:,1) <= hueThreshMax)) & ...
        (hsvI(:,:,2) >= satThreshMin) & (hsvI(:,:,2) <= satThreshMax) & ...
        (hsvI(:,:,3) >= valThreshMin) & (hsvI(:,:,3) <= valThreshMax);
end

% Remove blobs smaller than 25 px
greenMask = bwareaopen(greenMask, 25);

