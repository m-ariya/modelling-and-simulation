function [histogram] = findOutputWithDist(net,mem,distIn,distOut,iter,plotBool)
%FINDOUTPUTWITHDIST Find an output for a given distortion level which has a
% specific distance to the base image.
%   This function will perturb the provided memory 'mem' by 'distIn' pixels
%   and run it trough the network. Then, if the distance between the input
%   memory 'mem' and the generated output has distance 'distOut' then the
%   function will print the result in a plot. This will be repeated 'iter'
%   times.
%
%   Inputs
%   - net: a trained HopfieldNet object
%   - mem: the memory you want to distort
%   - distIn: the number or array of pixels to distort in mem
%   - distOut: the distance to mem for which you want to find the ourput
%   - iter: numer of times we want to generate an input
%   - plotBool: (default = true) set to false if you only want a histogram
%
%   Output
%   - histogram: return an array of size N+1 by 1 with the distances from
%      the output to 'mem'
    
    if nargin < 6
        plotBool = true;
    end
    
    distortions = max(size(distIn));
    
    histogram = zeros(net.N+1,distortions);
    for iterIdx = 1:iter
        for distIdx = 1:distortions
            memIn = distortmem(mem, distIn(distIdx));
            memOut = net.reconstruct(memIn);
            dist = hamdist(mem, memOut);
            histogram(dist + 1, distIdx) = histogram(dist + 1, distIdx) + 1;
            if plotBool && dist == distOut
                figure()
                image(reshape(memOut,8,8),'CDataMapping','scaled')
                title("Output memory")
                colorbar
            end
        end
    end
end

