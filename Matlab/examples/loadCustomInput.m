% Import images as an matrix with values between 0 and 1
img_cir = rgb2gray(imread('Images/circle.png')) / 255;
img_squ = rgb2gray(imread('Images/square.png')) / 255;
img_tri = rgb2gray(imread('Images/triangle.png')) / 255;
img_sta = rgb2gray(imread('Images/star.png')) / 255;

% Rescale the matrices to vectors ant convert from uint8 to double
cir = double(reshape(img_cir,1,[]));
squ = double(reshape(img_squ,1,[]));
tri = double(reshape(img_tri,1,[]));
sta = double(reshape(img_sta,1,[]));
% Transform to [-1 1] 
cir(cir == 0) = -1;
squ(squ == 0) = -1;
tri(tri == 0) = -1;
sta(sta == 0) = -1;

% Define memory array
% n: #neurons, m: #memories
memories = [sta;cir;squ;tri];
memories = rand(4,64);
memories(memories < 0.5) = -1;
memories(memories >= 0.5) = 1;

% (Optional) Provide a name corresponding to each memory
memories_names = ["star", "circle", "square", "triangle"];