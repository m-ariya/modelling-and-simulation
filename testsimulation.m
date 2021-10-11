clear all;
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

% Define memory array
% n: #neurons, m: #memories
memories = [cre;cir;squ;tri];
memories_names = ["creeper", "circle", "square", "triangle"];
[m,n] = size(memories);

%% ------ Train models ------
hebi_net = HopfieldNet(64, 'Hebbian');
hebi_net = hebi_net.train(memories);

stor_net = HopfieldNet(64, 'Storkey');
stor_net = stor_net.train(memories);

proj_net = HopfieldNet(64, 'Projection');
proj_net = proj_net.train(memories);

%% Define output matrix
% The dimensions in the output are defined as (x,y,z)
%   x := the distance from the input image to that memory   ([0,64])
%   y := the distance from the output image to that memory  ([0,64])
%   z := a specific memory                                  ([0,m])
hebi_output = zeros(n+1,n+1,m);
stor_output = zeros(n+1,n+1,m);
proj_output = zeros(n+1,n+1,m);

%% ------ Run simulation ------
num_iter = 10000;
dist_start = 0;
dist_end = 64;


% For each memory
for mem_idx = 1:m
    % For each level of distortion
    for distortion_level = dist_start:dist_end
        % Run for 'iterations' iterations
        for iter = 1:num_iter
            % Distort the current memory based on the current distortion level
            mem = distortmem(memories(mem_idx,:), distortion_level);
            
            % Compute the hamming distance of the distorted image to every
            %  base image
            mem_in_dist = zeros(1,m);
            for i = 1:m
                mem_in_dist(i) = hamdist(memories(i,:), mem) + 1;
            end
            
            % Compute the output for each given model
            hebi_out = hebi_net.reconstruct(mem);
            stor_out = stor_net.reconstruct(mem);
            proj_out = proj_net.reconstruct(mem);
            
            % Compute the distance from each output to each input and store
            for i = 1:m
                hebi_output(mem_in_dist(i),hamdist(memories(i,:), hebi_out) + 1,i) = hebi_output(mem_in_dist(i),hamdist(memories(i,:), hebi_out) + 1,i) + 1;
                stor_output(mem_in_dist(i),hamdist(memories(i,:), stor_out) + 1,i) = stor_output(mem_in_dist(i),hamdist(memories(i,:), stor_out) + 1,i) + 1;
                proj_output(mem_in_dist(i),hamdist(memories(i,:), proj_out) + 1,i) = proj_output(mem_in_dist(i),hamdist(memories(i,:), proj_out) + 1,i) + 1;
            end
        end
    end
    fprintf('Finished memory -%s-\n', memories_names(mem_idx))
end

%% ------ Normalise data ------
% Normalise each  row of the output plot such that we see the persentages
% instead of a heatmap
for mem_idx = 1:m
    for n_idx = 1:n+1
        % Hebbian
        maxVal = max(hebi_output(n_idx,:,mem_idx));
        hebi_output(n_idx,:,mem_idx) = hebi_output(n_idx,:,mem_idx) / maxVal;
        
        % Storkey
        maxVal = sum(stor_output(n_idx,:,mem_idx));
        stor_output(n_idx,:,mem_idx) = stor_output(n_idx,:,mem_idx) / maxVal;
        
        % Projection
        maxVal = sum(proj_output(n_idx,:,mem_idx));
        proj_output(n_idx,:,mem_idx) = proj_output(n_idx,:,mem_idx) / maxVal;
    end
end

%% ------ Print output ------
gridRow = 2; 
gridCol = 2;

figure('Name','Hebbian')
for i = 1:m
    subplot(gridRow,gridCol,i);
    image(hebi_output(:,:,i),'CDataMapping','scaled');
    title(memories_names(i))
    xlabel('Hamming distance of output to memory')
    ylabel('Hamming distance of input to memory')
    colorbar
end

figure('Name','Storkey')
for i = 1:m
    subplot(gridRow,gridCol,i);
    image(stor_output(:,:,i),'CDataMapping','scaled');
    title(memories_names(i))
    xlabel('Hamming distance of output to memory')
    ylabel('Hamming distance of input to memory')
    colorbar
end

figure('Name','Pseudo-Inverse')
for i = 1:m
    subplot(gridRow,gridCol,i);
    image(proj_output(:,:,i),'CDataMapping','scaled');
    title(memories_names(i))
    xlabel('Hamming distance of output to memory')
    ylabel('Hamming distance of input to memory')
    colorbar
end