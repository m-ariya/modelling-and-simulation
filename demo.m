% This small demo shows a simple visual example of how Hopfield network
% can reconstruct distorted patterns. This script did not contribute any
% results to the report.

% Setting the path 
folder = fileparts(which(mfilename)); 
addpath(genpath(folder));

% Reading patterns to binary vectors
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
run_demo(memories)

% Main function of the demo, allows configuration on leraning rule, pattern
% and distortion level
function run_demo(memories)
% Initialize
rule = 'Hebbian';
pattern = 'Creeper';
m = 1;
distortionLevel = 0;
distorted = zeros(1,64);

f = figure;
img = reshape(memories(m,:), 8, 8);
imagesc(img); 
axis square;
axis off;
colormap(bone);
drawnow;
title('Flipped bits: 0')

% Set up control for the learning rule
ct = uicontrol(f,'Style','text', 'String', 'Learning:');
ct.Position = [20 370 60 20];
cRule = uicontrol(f,'Style','popupmenu');
cRule.Position = [20 355 60 20];
cRule.String = {'Hebbian','Storkey','Projection'};
cRule.Callback = @selectRule;

% Set up control for the pattern
ct = uicontrol(f,'Style','text', 'String', 'Pattern:');
ct.Position = [20 325 60 20];
cPattern = uicontrol(f,'Style','popupmenu');
cPattern.Position = [20 310 60 20];
cPattern.String = {'Creeper','Circle','Square', 'Triangle'};
cPattern.Callback = @selectPattern;

% Set up control for the distortion level
ct = uicontrol(f,'Style','text', 'String', 'Distort:');
ct.Position = [20 280 60 20];
cDist = uicontrol(f,'Style','slider', 'Max',64,'Min',0, 'Value', distortionLevel);
cDist.Position = [20 265 60 20];
cDist.Callback = @store;

% Set up control for the reconstruction button
cButton = uicontrol;
cButton.Position = [20 225 60 20];
cButton.String = 'Reconstruct';
cButton.Callback = @reconstruct;

    function  selectRule(src,event)
        val = cRule.Value;
        str = cRule.String;
        str{val};
        disp(['Selection: ' str{val}]);
        rule = str{val};
    end

    function  selectPattern(src,event)
        distortionLevel = 0;
        cDist.Value = 0;
        val = cPattern.Value;
        str = cPattern.String;
        str{val};
        disp(['Selection: ' str{val}]);
        pattern =  str{val};
        
        switch pattern
            case 'Creeper'
                m = 1;
            case 'Circle'
                m = 2;
            case 'Square'
                m = 3;
            case 'Triangle'
                m = 4;
        end
        
        img = reshape(memories(m,:), 8, 8);
        imagesc(img); 
        axis square;
        axis off;
        colormap bone;
        drawnow;
        title('Flipped bits: 0')
    end


    function store(src, event)
        val = cDist.Value;
        distortionLevel = round(val);
        distorted = distortmem(memories(m, :), distortionLevel);
        img = reshape(distorted, 8, 8);
        imagesc(img); 
        axis square;
        colormap bone;
        axis off;
        drawnow;
        title(['Flipped bits: ', num2str(distortionLevel)]);
        
    end

    function reconstruct(src,event)
        net = HopfieldNet(64,rule);
        net = net.train(memories);
        reconstructed = net.reconstructVisually(distorted);
        title(['Hamming distance: ', num2str(hamdist(memories(m, :),reconstructed))]);
    end
end
