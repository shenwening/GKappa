clear; clc; close all; %Clear variables/command line/close old figures to avoid interference
%% 1. Read/prepare three pictures of the same size data\kn\datak\K1_5_K2_10_N50_GKappa_Fit_Curve.png
%img1 = imread('data\kn\datak\K1_5_K2_10_N50_GKappa_Fit_Curve.png'); % Replace with your image path
% img2 = imread('data\kn\datak\K1_5_K2_10_N10-1000_Iter20_GKappa_Fit_Curve.png');
% img3 = imread('data\kn\datak\K1_3-200_K2_13-210_Iter20_GKappa_Fit_Curve.png');
% 
%% (optional) Unify image size (if different sizes)
%img1 = imresize(img1, [400, 600]); % unified to height 400 and width 600
% img2 = imresize(img2, [400, 600]);
% img3 = imresize(img3, [400, 600]);
% 
%% 2. Stitch pictures
%% Horizontal splicing (merging by columns)
% combined_horizontal = cat(2, img1, img2, img3);  
%% Vertical splicing (merge by row)
% % combined_vertical = cat(1, img1, img2, img3);
% 
%% 3. Display and save
%figure; imshow(combined_horizontal); axis off; % turn off the coordinate axis
%imwrite(combined_horizontal, 'combined_image.png'); % Save as PNG
%% Or save it as SVG (vector image, you need to draw it first and then export it)
% % exportgraphics(gcf, 'combined_image.svg', 'ContentType', 'vector');




%1. Read/prepare three pictures of the same size data\kn\datak\K1_5_K2_10_N50_GKappa_Fit_Curve.png
img1 = imread('data\kn\data\K10_N50_GKappa_Fit_Curve.png');  %Replace with your image path
img2 = imread('data\kn\data\K10_N10-1000_Iter20_GKappa_Fit_Curve.png');
img3 = imread('data\kn\data\K3-200_N=2K_Iter20_GKappa_Fit_Curve.png');

%(Optional) Uniform image size (if different sizes)
img1 = imresize(img1, [400, 600]);  %Unified to a height of 400 and a width of 600
img2 = imresize(img2, [400, 600]);
img3 = imresize(img3, [400, 600]);

%2. Stitch pictures
%Horizontal splicing (merging by columns)
combined_horizontal = cat(2, img1, img2, img3);  
%Vertical splicing (merge by row)
% combined_vertical = cat(1, img1, img2, img3);

%3. Display and save
figure; imshow(combined_horizontal); axis off;  %Turn off axis
imwrite(combined_horizontal, 'kn_same_scale.png');  %Save as PNG
%Or save as SVG (vector image, you need to draw first and then export)
% exportgraphics(gcf, 'combined_image.svg', 'ContentType', 'vector');