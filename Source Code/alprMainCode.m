%% Vehicle License Plate Detection and Recognition using HSV Colour Space
% Developed under MATLAB R2023a. Requires the Image Processing Toolbox.
% Clear command windows
clc; clear all; close all;

%% Read the input image
[file,path] = uigetfile({'*.jpeg;*.jpg;*.png;*.bmp','All Image Files'},...
    'Select an image','Test Images');
inputI = [path,file];
inputI = imread(inputI);

% Display original image
figure, subplot(3,5,1), imshow(inputI), title('Original Image');

%% Reduce noise in the image
denoisedI = imgaussfilt3(inputI);
subplot(3,5,2), imshow(denoisedI), title('Denoised Image');

%% Convert preprocessed RGB image to HSV colour space
hsvI = rgb2hsv(denoisedI);
subplot(3,5,3), imshow(hsvI), title('HSV Image');

%% Create binary mask based on colour
blackMask = blackthresh(hsvI);
whiteMask = whitethresh(hsvI);
redMask = redthresh(hsvI);
greenMask = greenthresh(hsvI);
blueMask = bluethresh(hsvI);
yellowMask = yellowthresh(hsvI);

%% Find the connected components (region) in the binary masks
% Black mask
blackCC = bwconncomp(blackMask);
blackStats = regionprops(blackCC, 'Area', 'Centroid', 'BoundingBox');
% Filter potential region based on expected area/size and position
blackAreaIdx = filterarea(blackStats, size(blackMask));
blackPositionIdx = filterposition(blackStats, size(blackMask));
% Find whether there is any common components indices between result filtered by area and by position
% If there is, the common indices will be returned
blackIdx = intersect(blackPositionIdx, blackAreaIdx);
% Creates a binary mask based on the labels in the connected components data structure 
% that correspond to the indices
blackPlateMask = ismember(labelmatrix(blackCC), blackIdx);
subplot(3,5,4), imshow(blackPlateMask);title('Potential Plate from Black');

% White mask
whiteCC = bwconncomp(whiteMask);
whiteStats = regionprops(whiteCC, 'Area', 'Centroid', 'BoundingBox');
% Filter potential region based on expected area/size and position
whiteAreaIdx = filterarea(whiteStats, size(whiteMask));
whitePositionIdx = filterposition(whiteStats, size(whiteMask));
% Find whether there is any common components indices between result filtered by area and by position
% If there is, the common indices will be returned
whiteIdx = intersect(whitePositionIdx, whiteAreaIdx);
% Creates a binary mask based on the labels in the connected components data structure 
% that correspond to the indices
whitePlateMask = ismember(labelmatrix(whiteCC), whiteIdx);
subplot(3,5,5), imshow(whitePlateMask), title('Potential Plate from White');

% Red mask
redCC = bwconncomp(redMask);
redStats = regionprops(redCC, 'Area', 'Centroid', 'BoundingBox');
% Filter potential region based on expected area/size and position
redAreaIdx = filterarea(redStats, size(redMask));
redPositionIdx = filterposition(redStats, size(redMask));
% Find whether there is any common components indices between result filtered by area and by position
% If there is, the common indices will be returned
redIdx = intersect(redPositionIdx, redAreaIdx);
% Creates a binary mask based on the labels in the label matrix
% that correspond to the indices
redPlateMask = ismember(labelmatrix(redCC), redIdx);
subplot(3,5,6), imshow(redPlateMask), title('Potential Plate from Red');

% Green mask
greenCC = bwconncomp(greenMask);
greenStats = regionprops(greenCC, 'Area', 'Centroid', 'BoundingBox');
% Filter potential region based on expected area/size and position
greenAreaIdx = filterarea(greenStats, size(greenMask));
greenPositionIdx = filterposition(greenStats, size(greenMask));
% Find whether there is any common components indices between result filtered by area and by position
% If there is, the common indices will be returned
greenIdx = intersect(greenPositionIdx, greenAreaIdx);
% Creates a binary mask based on the labels in the connected components data structure 
% that correspond to the indices
greenPlateMask = ismember(labelmatrix(greenCC), greenIdx);
subplot(3,5,7), imshow(greenPlateMask), title('Potential Plate from Green');

% Blue mask
blueCC = bwconncomp(blueMask);
blueStats = regionprops(blueCC, 'Area', 'Centroid', 'BoundingBox');
% Filter potential region based on expected area/size and position
blueAreaIdx = filterarea(blueStats, size(blueMask));
bluePositionIdx = filterposition(blueStats, size(blueMask));
% Find whether there is any common components indices between result filtered by area and by position
% If there is, the common indices will be returned
blueIdx = intersect(bluePositionIdx, blueAreaIdx);
% Creates a binary mask based on the labels in the connected components data structure 
% that correspond to the indices
bluePlateMask = ismember(labelmatrix(blueCC), blueIdx);
subplot(3,5,8), imshow(bluePlateMask), title('Potential Plate from Blue');

% Yellow mask
yellowCC = bwconncomp(yellowMask);
yellowStats = regionprops(yellowCC, 'Area', 'Centroid', 'BoundingBox');
% Filter potential region based on expected area/size and position
yellowAreaIdx = filterarea(yellowStats, size(yellowMask));
yellowPositionIdx = filterposition(yellowStats, size(yellowMask));
% Find whether there is any common components indices between result filtered by area and by position
% If there is, the common indices will be returned
yellowIdx = intersect(yellowPositionIdx, yellowAreaIdx);
% Creates a binary mask based on the labels in the connected components data structure 
% that correspond to the indices
yellowPlateMask = ismember(labelmatrix(yellowCC), yellowIdx);
subplot(3,5,9), imshow(yellowPlateMask), title('Potential Plate from Yellow');

%% Obtain final connected components from black and white binary masks
% Extract the details of the final connected components from black and white masks
% after filtering for area and position
blackCC = bwconncomp(blackPlateMask);
whiteCC = bwconncomp(whitePlateMask);

%% Obtain and combine final connected components from red, green, blue & yellow binary masks
% Extract the details of the final connected components from colour masks
% after filtering for area and position
redCC = bwconncomp(redPlateMask);
greenCC = bwconncomp(greenPlateMask);
blueCC = bwconncomp(bluePlateMask);
yellowCC = bwconncomp(yellowPlateMask);

% Combine the details of the connected components in new data strucuture
% for only red, green, blue, and yellow
colourCC = redCC;
colourCC.PixelIdxList = [colourCC.PixelIdxList [greenCC.PixelIdxList [blueCC.PixelIdxList [yellowCC.PixelIdxList]]]];
colourCC.NumObjects = colourCC.NumObjects + greenCC.NumObjects + blueCC.NumObjects + yellowCC.NumObjects;
% colourCC % to check details of data structure

%% Edge detection to find potential license plate region
grayI = rgb2gray(inputI); % convert to grayscale
% figure, subplot(2,2,1), imshow(grayI), title('Grayscale Image');

% Reduce noise in gray image
filteredGray = medfilt2(grayI);
% subplot(2,2,2), imshow(filteredGray), title('Denoised Grayscale Image');

% Detect edges using sobel operator
grayEdge = edge(filteredGray, 'sobel', 'vertical');
% subplot(2,2,3), imshow(grayEdge), title('Sobel Edge Detection Image');

% Morphologically process the edges to form the rectangle shape of the
% plate
edgeMask = imdilate(grayEdge, strel('rectangle', [5 10]));
edgeMask = imclose(edgeMask, strel('rectangle', [5 15]));
edgeMask = imopen(edgeMask, strel('rectangle', [17 30]));
edgeMask = imdilate(edgeMask, strel('rectangle', [1 10]));
edgeMask = imclose(edgeMask, strel('rectangle', [5 15]));
% subplot(2,2,4), imshow(edgeMask), title('Edge Detection Image After Morphological Operations');

% Find the connected components in the mask obtained from edge detection
edgeCC = bwconncomp(edgeMask);
edgeStats = regionprops(edgeCC, 'Area', 'Centroid', 'BoundingBox');
% Filter potential region based on expected area/size and position
edgeAreaIdx = filterarea(edgeStats, size(edgeMask));
edgePositionIdx = filterposition(edgeStats, size(edgeMask));
% Find whether there is any common components indices between result filtered by area and by position
% If there is, the common indices will be returned
edgeIdx = intersect(edgePositionIdx, edgeAreaIdx);
% Creates a binary mask based on the labels in the connected components data structure 
% that correspond to the indices
edgePlateMask = ismember(labelmatrix(edgeCC), edgeIdx);
subplot(3,5,10), imshow(edgePlateMask), title('Potential Plate from Edge Detection');

% Obtain the details of the final connected component after filtering for area and position
edgeCC = bwconncomp(edgePlateMask);

%% Determine overlap between the bounding boxes
% of the edge connected components and colour, black and white connected components
% to extract license plate region based on bounding boxes
% The greater the overlap, the more likely that region is the license plate

% Colour connected components with edge connected components
plateFound = false;
maxRatio = 0;

overlapRatio = calcoverlap(colourCC, edgeCC);
if ~isempty(overlapRatio)
    [maxOverlapRatio, maxRatioIdx] = max(overlapRatio, [], 'all');
    [colourCCIdx, edgeCCIdx] = ind2sub(size(overlapRatio), maxRatioIdx);

    if maxOverlapRatio > 0.7
        plateFound = true;
        % segment based on colour connected component region
        plateCC = colourCC;
        plateIdx = colourCCIdx;
    elseif maxOverlapRatio > 0
        maxRatio = maxOverlapRatio;
        plateCC = colourCC;
        plateIdx = colourCCIdx;
    end
end

% If plate not found, proceed to find overlap between potential ROIs
% from white connected components and edge connected components
if ~plateFound
    overlapRatio = calcoverlap(whiteCC, edgeCC);
    if ~isempty(overlapRatio)
        [maxOverlapRatio, maxRatioIdx] = max(overlapRatio, [], 'all');
        [whiteCCIdx, edgeCCIdx] = ind2sub(size(overlapRatio), maxRatioIdx);

        if maxOverlapRatio > 0.6
            plateFound = true;
            % segment based on white connected component region
            plateCC = whiteCC;
            plateIdx = whiteCCIdx;
        elseif maxOverlapRatio > maxRatio
            % update maxRatio
            maxRatio = maxOverlapRatio;
            plateCC = whiteCC;
            plateIdx = whiteCCIdx;
        end
    end
end

% If plate not found, proceed to find overlap between potential ROIs
% from black connected components and edge connected components
if ~plateFound
    overlapRatio = calcoverlap(blackCC, edgeCC);
    if ~isempty(overlapRatio)
        [maxOverlapRatio, maxRatioIdx] = max(overlapRatio, [], 'all');
        [blackIdx, edgeCCIdx] = ind2sub(size(overlapRatio), maxRatioIdx);

        if maxOverlapRatio > 0.3
            plateFound = true;
            % segment based on edge connected component region
            plateCC = edgeCC;
            plateIdx = edgeCCIdx;
        end
    end
end

% If plate not found, use connected component(s) from edge detection
if ~plateFound && edgeCC.NumObjects == 1
    [plateFound, plateCC, plateIdx] = deal(true, edgeCC, 1);
end


%% If plate is found, perform OCR and display results
if plateFound
    % Extract the bounding box of license plate
    plateStats = regionprops(plateCC);

    % Crop the license plate region from the original image & binarize
    licensePlate = imcrop(inputI, plateStats(plateIdx).BoundingBox);
    grayPlate = rgb2gray(licensePlate); % convert to grayscale image
    bwPlate = imbinarize(grayPlate); % convert to binary image
    % figure, imshow(bwPlate); % display binary image 

    % Fill in holes and missing pixels in the numbers and letters so that OCR can perform better
    bwPlate = imdilate(bwPlate,strel('line',1,90));

    % Perform OCR on the license plate region
    alphanumerics = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 ';
    ocrResults = ocr(bwPlate,'CharacterSet',alphanumerics,'LayoutAnalysis','block');

    % Display OCR results
    subplot(3,5,13), imshow(licensePlate), title(['License Plate Recognition: ' ocrResults.Text], ...
        'Color', [0 0.5 0], 'HorizontalAlignment', 'center');
else
    % If plate not found/OCR cannot read the plate, display error message
    subplot(3,5,13), title('License Plate Recognition: Unable to detect vehicle license plate.', ...
        'Color', [0.6350 0.0780 0.1840], 'HorizontalAlignment', 'center');
end

