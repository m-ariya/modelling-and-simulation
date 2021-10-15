function [histogram] = findOutWithDist(net,mem,distIn,distOut,iter)
%FINDOUTWITHDIST Summary of this function goes here
%   Detailed explanation goes here
    % Set default values
    
    histogram = zeros(65,1);
    for idx = 1:iter
        mem_in = distortmem(mem, distIn);
        mem_out = net.reconstruct(mem_in);
        dist = hamdist(mem, mem_out);
        histogram(dist + 1) = histogram(dist + 1) + 1;
        if dist == distOut
            figure()
            image(reshape(mem_out,8,8),'CDataMapping','scaled')
            title("Output memory")
            colorbar
        end
    end
end

