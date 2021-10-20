clear all;
%% ------ Load input ------
% load memories and memoryNames
load('Matlab/input/imagePaterns.mat')
[m,n] = size(memories);

%% ------- Print distance matrix of original images ------
% Compute the distance between memories
%% ------- Print distance matrix of original images ------
% Compute the distance between memories
distMemories = zeros(m,m);
for i = 1:m
    for j = 1:m
        distMemories(i,j) = hamdist(memories(i,:),memories(j,:));
    end
end
% This will give us a rough indication about how close the memories are to each other.
distMemories

%% ------ Train models ------
hebiNet = HopfieldNet(64, 'Hebbian');
hebiNet = hebiNet.train(memories);

storNet = HopfieldNet(64, 'Storkey');
storNet = storNet.train(memories);

projNet = HopfieldNet(64, 'Projection');
projNet = projNet.train(memories);

%% ------ Run simulation ------
hebiOutput = robustnessFunc(hebiNet, 10, 0:64);
storOutput = robustnessFunc(storNet, 10, 0:64);
projOutput = robustnessFunc(projNet, 10, 0:64);

%% ------ Robustness analysis plotting ------
gridRow = 2; 
gridCol = 2;

figure('Name','Hebbian')
for i = 1:m
    subplot(gridRow,gridCol,i);
    image(hebiOutput(:,:,i),'CDataMapping','scaled');
    title(memoryNames(i))
    xlabel('Distance: output -> memory')
    ylabel('Distance: input -> memory')
    colorbar
    grid on
end

figure('Name','Storkey')
for i = 1:m
    subplot(gridRow,gridCol,i);
    image(storOutput(:,:,i),'CDataMapping','scaled');
    title(memoryNames(i))
    xlabel('Distance: output -> memory')
    ylabel('Distance: input -> memory')
    colorbar
    grid on
end

figure('Name','Pseudo-Inverse')
for i = 1:m
    subplot(gridRow,gridCol,i);
    image(projOutput(:,:,i),'CDataMapping','scaled');
    title(memoryNames(i))
    xlabel('Distance: output -> memory')
    ylabel('Distance: input -> memory')
    colorbar
    grid on
end

%% ------ Accuracy annalysis data preperation ------
% Add all samples to a single matrix
hebiSumOutput = zeros(n+1,n+1);
storSumOutput = zeros(n+1,n+1);
projSumOutput = zeros(n+1,n+1);
for mem_idx = 1:m
    hebiSumOutput = hebiOutput(:,:,mem_idx);
    storSumOutput = storOutput(:,:,mem_idx);
    projSumOutput = projOutput(:,:,mem_idx);
end

% Normalise each distortion level
for idx = 1:n+1
    hebiSumOutput(idx,:) = hebiSumOutput(idx,:) / sum(hebiSumOutput(idx,:));
    storSumOutput(idx,:) = storSumOutput(idx,:) / sum(storSumOutput(idx,:));
    projSumOutput(idx,:) = projSumOutput(idx,:) / sum(projSumOutput(idx,:));
end

%% ------ Accuracy annalysis plotting ------
figure('Name','Accuracy')
plot(1:n+1,hebiSumOutput(:,1),'LineWidth',1.5)
hold on
plot(1:n+1,storSumOutput(:,1),'LineWidth',1.5)
plot(1:n+1,projSumOutput(:,1),'LineWidth',1.5)
hold off
xlabel('Number of bits flipped in input')
ylabel('Accuracy')
legend('Hebbian', 'Storkey', 'Pseudo-inverse')
grid on
grid minor