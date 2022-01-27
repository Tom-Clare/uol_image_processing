clear; close all;

% Task 1: Pre-processing -----------------------
% Step-1: Load input image
I = imread('IMG_01.png');


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
%imshow(I);

I_edge = edge(I_edge, 'canny');

%imshow(I);

%% Task 3: Simple segmentation --------------------
I_binA = imclearborder(I_bin); % get objects not attached to border
I_binA = imfill(I_binA, "holes"); % fill in holes

I_binB = I_bin - I_binA; % get only border-touching objects
I_binB = bwconvhull(I_binB, "objects"); % and get their outline via bwconvhull()

I_bin = I_binA + I_binB; % add 
imshow(I_bin);

% Task 4: Object Recognition --------------------