tic;
%% Load Image
rgb = imread('...\verbose-spork\images\Agar.io images\imagebw (20).png');
figure
imshow(rgb)
%% 
I = rgb2gray(rgb);
imshow(I)
%%
t = find(I<200 & I>150);
I(t) = 1;
imshow(I)
% %% Can Skip this
% I(I>201) = 255;
% imshow(I)
%%
BW = im2bw(I);
figure(1);
imshow(BW);
hold on;
%%
B = bwboundaries(BW);
s=size(B);
objcenters=zeros(s(1),2);
objsize=zeros(s(1));
for i=1:s(1)
    bb=B{i};
    plot(bb(:,2),bb(:,1));
    objcenters(i,1)=mean(bb(:,1));
    objcenters(i,1)=mean(bb(:,2));
    
    objsize(i)=polyarea(bb(:,1),bb(:,2));
end

toc;