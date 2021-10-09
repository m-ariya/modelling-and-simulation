clear;

%% ------ Prepare input ------

% Import images as an matrix with values between 0 and 1
img_cir = rgb2gray(imread('Images/circle.png')) / 255;
img_squ = rgb2gray(imread('Images/square.png')) / 255;
img_tri = rgb2gray(imread('Images/triangle.png')) / 255;
img_cre = rgb2gray(imread('Images/creeper.png')) / 255;

% Rescale the matrices to vectors ant convert from uint8 to double
cir = double(reshape(img_cir,1,[]));
squ = double(reshape(img_squ,1,[]));
tri = double(reshape(img_tri,1,[]));
cre = double(reshape(img_cre,1,[]));

% Transform to [-1 1] 
cir(cir == 0) = -1;
squ(squ == 0) = -1;
tri(tri == 0) = -1;
cre(cre == 0) = -1;

memories = [cre;cir;squ;tri];

% Test image we want to use
testMemo = memories(1,:);
% Number of flipped pixels in disturbed input
size = 64;
flippedNum = 30; 
flippedIdx = randi(size, 1, flippedNum);
testMemoDisturbed = testMemo;
testMemoDisturbed(flippedIdx) = -1*testMemo(flippedIdx);

gridRow = 2; 
gridCol = 2;

%% ------ Simulation Hebbian ------
heb_net = HopfieldNet(size, 'Hebbian');
heb_net = heb_net.train(memories);

% Plot undistorted input
figure('Name','Hebbian')
subplot(gridRow,gridCol,1);
image(reshape(testMemo,8,8),'CDataMapping','scaled')
title("Input")
colorbar

% Plot undistorted output
subplot(gridRow,gridCol,2);
image(reshape(heb_net.reconstruct(testMemo),8,8),'CDataMapping','scaled')
title("Output")
colorbar

% Plot distorted input
subplot(gridRow,gridCol,3);
image(reshape(testMemoDisturbed,8,8),'CDataMapping','scaled')
title("Distorted input")
colorbar

% Plot distorted output
subplot(gridRow,gridCol,4);
image(reshape(heb_net.reconstruct(testMemoDisturbed),8,8),'CDataMapping','scaled')
title("Output")
colorbar

%% ------ Simulation Storkey ------
stor_net = HopfieldNet(size, 'Storkey');
stor_net = stor_net.train(memories);

% Plot undistorted input
figure('Name','Storkey')
subplot(gridRow,gridCol,1);
image(reshape(testMemo,8,8),'CDataMapping','scaled')
title("Input")
colorbar

% Plot undistorted output
subplot(gridRow,gridCol,2);
image(reshape(stor_net.reconstruct(testMemo),8,8),'CDataMapping','scaled')
title("Output")
colorbar

% Plot distorted input
subplot(gridRow,gridCol,3);
image(reshape(testMemoDisturbed,8,8),'CDataMapping','scaled')
title("Distorted input")
colorbar

% Plot distorted output
subplot(gridRow,gridCol,4);
image(reshape(stor_net.reconstruct(testMemoDisturbed),8,8),'CDataMapping','scaled')
title("Output")
colorbar

%% ------ Simulation Pseudo-inverse (projection) ------

proj_net = HopfieldNet(size, 'Projection');
proj_net = proj_net.train(memories);

% Plot undistorted input
figure('Name','Pseudo-Inverse')
subplot(gridRow,gridCol,1);
image(reshape(testMemo,8,8),'CDataMapping','scaled')
title("Input")
colorbar

% Plot undistorted output
subplot(gridRow,gridCol,2);
image(reshape(stor_net.reconstruct(testMemo),8,8),'CDataMapping','scaled')
title("Output")
colorbar

% Plot distorted input
subplot(gridRow,gridCol,3);
image(reshape(testMemoDisturbed,8,8),'CDataMapping','scaled')
title("Distorted input")
colorbar

% Plot distorted output
subplot(gridRow,gridCol,4);
image(reshape(stor_net.reconstruct(testMemoDisturbed),8,8),'CDataMapping','scaled')
title("Output")
colorbar
