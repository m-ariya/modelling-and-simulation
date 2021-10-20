function difNum = hamdist(memory1,memory2)
%HAMDIST Compute the difference between 2 memories / images
%   The function computes the difference between 2 euivelently sized
%   vectors/matrices, assuming both inputs only contain 1 and -1 values.
%
%   Input
%   - memory1: a memory vertor containing values -1 and 1
%   - memory2: a memory vertor containing values -1 and 1
%
%   Output
%   - difNum: Number of differences between the input memories

    difNum = sum(sum(xor((memory1+1)/2, (memory2+1)/2)));
end