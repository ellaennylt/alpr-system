% Compute bounding box overlap ratio from colour, black and white connected
% components with edge connected component
function overlapRatio = calcoverlap(colourbwCC, edgeCC)
colourbwStats = regionprops(colourbwCC, 'BoundingBox');
colourbwPropsTable = struct2table(colourbwStats);
colourbwBBox = table2array(colourbwPropsTable(:, 1));

edgeStats = regionprops(edgeCC, 'BoundingBox');
edgePropsTable = struct2table(edgeStats);
edgeBBox = table2array(edgePropsTable(:, 1));

unionRatio = bboxOverlapRatio(colourbwBBox, edgeBBox, 'Union');
minRatio = bboxOverlapRatio(colourbwBBox, edgeBBox,'Min');

overlapRatio = (unionRatio + minRatio)/2; % balanced measure of overlap

