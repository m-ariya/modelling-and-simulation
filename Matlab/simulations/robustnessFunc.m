function outputData = robustnessFunc(net, iterations, distortions)
%ROBUSTNESSFUNC runs the robustness simulation for a trained network
%
%   Inputs
%   - net: a trained HopfieldNet object
%   - iterations: number of iterations to repeat each distortion level
%       e.g.: 1000
%   - distortions: array containing the distortion level to be considered
%       e.g.: 0:10
%
%   Outputs
%   - outputData: a 3-dimensional matrix containing the data generated by
%      the simulation. The dimensions in the output are defined as (x,y,z)
%      x := the distance from the input image to that memory   ([1,n+1])
%      y := the distance from the output image to that memory  ([1,n+1])
%      z := a specific memory                                  ([1,m])

    % Define the number of neurons and number of memories
    n = net.N;
    m = net.numOfMemories;
    
    % Allocate the output matrix
    outputData = zeros(n+1, n+1, m);
    
    % For each memory
    for memIdx = 1:m
        % For each level of distortion
        for distortionLevel = distortions
            % Run for 'iterations' iterations
            for iter = 1:iterations
                % Distort the current memory based on the current distortion level
                memIn = distortmem(net.memories(memIdx,:), distortionLevel);

                % Compute the output for the given network
                memOut = net.reconstruct(memIn);

                % Compute the Hamming distance between the base memory and
                % the input and output
                distIn  = hamdist(net.memories(memIdx,:), memIn);
                distOut = hamdist(net.memories(memIdx,:), memOut);
                
                % Store these distances
                outputData(distIn+1, distOut+1, memIdx) = outputData(distIn+1, distOut+1, memIdx) + 1;
            end
        end
    end
end
