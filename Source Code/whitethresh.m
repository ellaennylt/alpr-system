% Extract white based on HSV threshold
function whiteMask = whitethresh(hsvI)

% Define white thresholds for hue, saturation and value channels
hueThreshMin = 0.000;
hueThreshMax = 1.000;
satThreshMin = 0.000;
satThreshMax = 0.200;
valThreshMin = 0.700;
valThreshMax = 1.000;

% Create mask based on chosen thresholds
if hueThreshMin > hueThreshMax
    whiteMask = ((hsvI(:,:,1) >= hueThreshMin) | (hsvI(:,:,1) <= hueThreshMax)) & ...
        (hsvI(:,:,2) >= satThreshMin) & (hsvI(:,:,2) <= satThreshMax) & ...
        (hsvI(:,:,3) >= valThreshMin) & (hsvI(:,:,3) <= valThreshMax);
else
    whiteMask = ((hsvI(:,:,1) >= hueThreshMin) & (hsvI(:,:,1) <= hueThreshMax)) & ...
        (hsvI(:,:,2) >= satThreshMin) & (hsvI(:,:,2) <= satThreshMax) & ...
        (hsvI(:,:,3) >= valThreshMin) & (hsvI(:,:,3) <= valThreshMax);
end

% Remove blobs smaller than 25 px
whiteMask = bwareaopen(whiteMask, 25);

