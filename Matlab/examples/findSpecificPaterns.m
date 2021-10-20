clear all;
%% ------ Load input ------
load('Matlab/input/imagePaterns.mat')
[m,n] = size(memories);

%% ------ Train model ------
hebi_net = HopfieldNet(n, 'Hebbian');
hebi_net = hebi_net.train(memories);

%% ------ Find an output for a given distortion level ------
distIn  = 20:25;
distOut = 32;
iter    = 1000;
hist = findOutputWithDist(hebi_net,memories(1,:),distIn,distOut,iter,true);
figure()
plot(0:n,hist)
legend(string(distIn));
grid minor
