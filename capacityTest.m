clear;

%% ------ Prepare input ------
% 200 randomly generated input memories

rng(123);  % seed for reproducibility
memoriesNum = 1000;
neuronsNum = 64;
memories = randi([0 1], memoriesNum, neuronsNum);
memories(memories == 0) = -1;


%% ------ Simulation settings ------
minCapacity = 1;
maxCapacity = 100;
maxIter = 10;  % max iterations per capacity
distortionLevel = 20; % number of flipped bits


%% ------ Simulation  ------
% instantiate networks
hebNet = HopfieldNet(neuronsNum, 'Hebbian');
storkeyNet = HopfieldNet(neuronsNum, 'Storkey');
projNet = HopfieldNet(neuronsNum, 'Projection');

% holders for average accuracies wrt to each capacity
hebAcc = zeros(maxCapacity,1);
storkeyAcc = zeros(maxCapacity,1);
projAcc = zeros(maxCapacity,1);

for capacity=minCapacity:maxCapacity
    % average accuracy per 'capacity' for all iterations
    hebAccPerCapacity = 0;
    storkeyAccPerCapacity = 0;
    projAccPerCapacity = 0;
    
    for i=1:maxIter
        % average accuracy per all memories in a subset
        hebAccPerSubset = 0;
        storkeyAccPerSubset  = 0;
        projAccPerSubset  = 0;
        
        % draw a random subset of size 'capacity' from memories
        randIdx = randi([1 memoriesNum], 1, capacity);
        memoriesSubset = memories(randIdx, :);
        
        % train all types of networks on these memories
        hebNet = hebNet.train(memoriesSubset);
        storkeyNet = storkeyNet.train(memoriesSubset);
        projNet = projNet.train(memoriesSubset);
        
        % reconstruct each  memory from the subset
        for memoryIdx=1:capacity
            mem = memoriesSubset(memoryIdx,:);
           
            % distort input if needed
            if distortionLevel > 0
                mem = distortmem(mem, distortionLevel);
            end
            
            hebOut = hebNet.reconstruct(mem);
            storkeyOut = storkeyNet.reconstruct(mem);
            projOut = projNet.reconstruct(mem);
            
            % compute accuracy for current subset (running average for memories in a subset)
            hebAccPerSubset = hebAccPerSubset + (hamdist(memoriesSubset(memoryIdx,:), hebOut) == 0)/capacity;
            storkeyAccPerSubset = storkeyAccPerSubset + (hamdist(memoriesSubset(memoryIdx,:), storkeyOut) == 0)/capacity;
            projAccPerSubset = projAccPerSubset + (hamdist(memoriesSubset(memoryIdx,:), projOut) == 0)/capacity;
            %hamdist(memoriesSubset(memoryIdx,:), hebOut)
            %hebOut
            %memoriesSubset(memoryIdx,:)
            
        end
        % compute accuracy for current capacity (running average for all iterations)
        hebAccPerCapacity =  hebAccPerCapacity + hebAccPerSubset/maxIter;
        storkeyAccPerCapacity =  storkeyAccPerCapacity + storkeyAccPerSubset/maxIter;
        projAccPerCapacity = projAccPerCapacity + projAccPerSubset/maxIter;
    end
    % add the average accuracy of all iterations for all capacities for each net
    hebAcc(capacity) = hebAccPerCapacity;
    storkeyAcc(capacity) = storkeyAccPerCapacity;
    projAcc(capacity) = projAccPerCapacity;
end


% plot
plot([minCapacity:maxCapacity], hebAcc,'LineWidth', 1.5, 'DisplayName','Hebbian')
hold on
plot([minCapacity:maxCapacity], storkeyAcc, 'LineWidth',1.5, 'DisplayName','Storkey')
hold on
plot([minCapacity:maxCapacity], projAcc, 'LineWidth',1.5, 'DisplayName','Pseudo-inverse');
%hold on
%heblim = N/(2*log2(N));
%storkeylim=;
xlabel('Number  of stored patterns') 
ylabel('Accuracy') 
legend('Location', 'best')
title(['Accuracy vs Capacity with distortion level=',num2str(distortionLevel)])
ylim([0,1])
grid on
grid minor

