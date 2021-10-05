clear;

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

memories = [cir;squ;tri];


% ------ Simulation ------
size = 64;
n = HopfieldNet(size, 'Hebbian');
n = n.train(memories);

% Test reconstruction of a full memory
testMemo = memories(1,:);
out = n.reconstruct(testMemo);

figure(1)
image(reshape(testMemo,8,8),'CDataMapping','scaled')
title("Input")
colorbar

figure(2)
image(reshape(out,8,8),'CDataMapping','scaled')
title("Output")
colorbar

% Test reconstruction of a corrupted memory
testMemo = memories(1,:);
flippedNum = 36; % lmao it works with 36 flipped bits
flippedIdx = randi(size, 1, flippedNum);
testMemo(flippedIdx) = -1*testMemo(flippedIdx);
out = n.reconstruct(testMemo);

figure(3)
image(reshape(testMemo,8,8),'CDataMapping','scaled')
title("Distorted input")
colorbar

figure(4)
image(reshape(out,8,8),'CDataMapping','scaled')
title("Output")
colorbar





