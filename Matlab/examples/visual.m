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

net = HopfieldNet(64, 'Hebbian');
net = net.train(memories);

m = distortmem(memories(1,:), 20);
mr = reshape(m, 8,8);
imagesc(mr); axis square; colormap bone; 
net.reconstructVisually(m);

