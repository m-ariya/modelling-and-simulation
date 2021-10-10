function memory = distortmem(memory,numFlips)
%DISTORTMEM Distorts the input memory by numFlip bits
    [n,m] = size(memory);
    randVec = randperm(n*m);
    randVec = randVec(1:numFlips);
    
    for idx = 1:numFlips
        if memory(randVec(idx)) == 1
            memory(randVec(idx)) = -1;
        else
            memory(randVec(idx)) = 1;
        end
    end
end

