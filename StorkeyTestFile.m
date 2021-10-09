clear all;

% ------ Prepare input ------

% Import images as an matrix with values between 0 and 1
img_cir = rgb2gray(imread('Images/circle.png')) / 255;
img_squ = rgb2gray(imread('Images/square.png')) / 255;
img_tri = rgb2gray(imread('Images/triangle.png')) / 255;
img_cre = rgb2gray(imread('Images/crecent.png')) / 255;

% Rescale the matrices to vectors ant convert from uint8 to double
cir = double(reshape(img_cir,1,[]));
squ = double(reshape(img_squ,1,[]));
tri = double(reshape(img_tri,1,[]));

% Transform to [-1 1] 
cir(cir == 0) = -1;
squ(squ == 0) = -1;
tri(tri == 0) = -1;

memories = [cir' squ' tri'];

% ------------- other code -------------

%memories = 2 * (randi(2,64,5) - 1.5);

W = zeros(64);

for idx = 1:3
    W = storkeyMatrix(memories(:,idx), W);
end

max(max(W))
min(min(W))

image(W,'CDataMapping','scaled')
title("Weight matrix")
colorbar