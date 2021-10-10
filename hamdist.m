function dif_num = hamdist(memory1,memory2)
%HAMDIST Compute the difference between 2 memories / images
%   The function computes the difference between 2 euivelently sized
%   vectors/matrices, assuming both inputs only contain 1 and -1 values.
    dif_num = sum(sum(xor((memory1+1)/2, (memory2+1)/2)));
end