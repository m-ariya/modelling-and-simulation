clear all;
%% ------ Prepare input ------
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
memories_names = ["star", "circle", "square", "triangle"];
[m,n] = size(memories);

% Compute the distance between memories
dist_memories = zeros(m,m);
for i = 1:m
    for j = 1:m
        dist_memories(i,j) = hamdist(memories(i,:),memories(j,:));
    end
end

%% ------ Train models ------
hebi_net = HopfieldNet(64, 'Hebbian');
hebi_net = hebi_net.train(memories);

%% Define output matrix
% The dimensions in the output are defined as (x,y,z)
%   x := the distance from the input image to that memory   ([0,64])
%   y := the distance from the output image to that memory  ([0,64])
%   z := a specific memory                                  ([0,m])
hebi_output = zeros(n+1,n+1,m);

%% ------ Run simulation ------
hist = findOutWithDist(hebi_net,sta,21,20,5000);
figure()
plot(0:64,hist)
grid minor
