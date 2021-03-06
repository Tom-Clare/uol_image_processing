clear; close all;

% Task 1: Pre-processing -----------------------
% Step-1: Load input image
I = imread('IMG_11.png');

% Step-2: Covert image to grayscale
I = rgb2gray(I);
%imshow(I);

% Step-3: Rescale image
I = imresize(I, [512, NaN]);
%imshow(I);

% Step-4: Produce histogram before enhancing
%imhist(I);

% Step-5: Enhance image before binarisation
I = medfilt2(I, [5,5]); 
%I = imadjust(I);

% Step-6: Histogram after enhancement
%imhist(I_histeq, 10);

% Step-7: Image Binarisation
% Use Otsu's method
G = graythresh(I);
I_bin = imbinarize(I, G);

% extra step to open and erode to further reduce noise
I_area = bwareaopen(I_bin, 400, 4);

%% Task 2: Edge detection ------------------------
I_edge = medfilt2(I, [12,12]);
I_edge = imadjust(I_edge, [], [], 3);

I_edge = edge(I_edge, 'canny');

%% Task 3: Simple segmentation --------------------
I_binA = imclearborder(I_bin); % get objects not attached to border
I_binA = imfill(I_binA, "holes"); % fill in holes

I_binB = I_bin & ~I_binA; % get only border-touching objects
I_binB = bwconvhull(I_binB, "objects"); % and get their outline via bwconvhull()

I_bin = I_binA + I_binB; % add border shapes to centre shapes

imshow(I_bin);

%% Task 4: Object Recognition --------------------
I_labelled = bwlabel(I_bin); % label each region
properties = regionprops(I_labelled, "Circularity"); % get circularity of regions
mask = [properties.Circularity] > 0.5; % only regions with over X circularity rating
I_circles = ismember(I_labelled, find(mask)); % match circular onjects to those in original image

I_noncircles = I_bin & ~I_circles;
%imshow(I_noncircular);

composite = cat(3, I_circles, I_noncircles, I_noncircles);
imshow(im2uint8(composite));

%% Ground Truth analysis
gt = imread("IMG_11_GT.png");
gt = rgb2gray(gt);
gt = label2rgb(gt, "hsv", "k");
gt = imresize(gt, [512, NaN]);

imshowpair(composite, gt, 'montage');
