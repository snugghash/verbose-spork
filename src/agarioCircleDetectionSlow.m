% Detect and Measure Circular Objects in an Image
%% Load Image
rgb = imread('imagebw (20).png');
figure
imshow(rgb)

%% Determine Radius Range for Searching Circles (Interactive)
d = imdistline;
delete(d);

%% Initial Attempt to Find Circles
gray_image = rgb2gray(rgb);
imshow(gray_image);
[centers, radii] = imfindcircles(rgb,[20 25],'ObjectPolarity','dark');
display(centers,radii);

%% Increase Detection Sensitivity
[centers, radii] = imfindcircles(rgb,[20 25],'ObjectPolarity','dark', ...
    'Sensitivity',0.9);

%% Draw the Circles on the Image
imshow(rgb);
h = viscircles(centers,radii);
[centers, radii] = imfindcircles(rgb,[20 25],'ObjectPolarity','dark', ...
    'Sensitivity',0.92);
length(centers)

delete(h);  % Delete previously drawn circles
h = viscircles(centers,radii);

%% Use the Second Method (Two-stage) for Finding Circles
[centers, radii] = imfindcircles(rgb,[20 25], 'ObjectPolarity','dark', ...
          'Sensitivity',0.92,'Method','twostage');
delete(h);
h = viscircles(centers,radii);

[centers, radii] = imfindcircles(rgb,[20 25], 'ObjectPolarity','dark', ...
          'Sensitivity',0.95,'Method','twostage');
delete(h);
viscircles(centers,radii);
