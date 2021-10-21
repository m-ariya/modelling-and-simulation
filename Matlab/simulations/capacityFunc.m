function outputData = capacityFunc(net, iterations, distortionLevel, capacities, memories)
%CAPACITYFUNC runs the robustness simulation for a trained network
%
%   Inputs
%   - net: a trained HopfieldNet object
%   - iterations: number of iterations to repeat for each capacity
%       e.g.: 10
%   - distortionLevel: number of corrupted bits in each pattern
%       e.g.: 0 (no distortion)
%   - capacities: array containing the capacities to be considered
%       e.g.: 1:10
%   -  memories: m x N matrix, where m is the total number of patterns, and
%       N is the number of neurons in a network
%
%   Outputs
%   - outputData: an array containing the average accuracy for each
%   condidered capacity, where index corresponds to the capacity.
%      
    % Define seed for reproducibility
    %rng(123);
    
    [m,~] = size(memories);
    
    % Define min and max capacities to consider
    minCapacity = capacities(1);
    maxCapacity = capacities(end);
    
    % Allocate the output matrix
    outputData =  zeros(maxCapacity,1);
    
    for capacity=minCapacity:maxCapacity
    % Average accuracy per 'capacity' for all iterations
    accPerCapacity = 0;
    
    for i=1:iterations
        % Average accuracy per all memories in a subset
        accPerSubset = 0;
        
        % Draw a random subset of size 'capacity' from memories
        randIdx = randi([1 m], 1, capacity);
        memoriesSubset = memories(randIdx, :);
        
        % Train the network on these memories
        net = net.train(memoriesSubset);
        
        % Reconstruct each  memory from the subset
        for memoryIdx=1:capacity
            memIn = memoriesSubset(memoryIdx,:);
           
            % Distort input if needed
            if distortionLevel > 0
                memIn = distortmem(memIn, distortionLevel);
            end
            
            memOut = net.reconstruct(memIn);
            
            % Compute accuracy for current subset (running average for memories in a subset)
            accPerSubset = accPerSubset + (hamdist(memoriesSubset(memoryIdx,:), memOut) == 0)/capacity;
            
        end
        % Compute accuracy for current capacity (running average for all iterations)
        accPerCapacity =  accPerCapacity + accPerSubset/iterations;
  
    end
    % Add the average accuracy of all iterations for all capacities for each net
    outputData(capacity) = accPerCapacity;
    end
end


