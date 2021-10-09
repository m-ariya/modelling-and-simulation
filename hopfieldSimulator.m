clear all;

% Generate random memories
memories = 2 * (randi(2,64,5) - 1.5);

% Number of neurons and memories
[n, m] = size(memories);

W = zeros(n,n);

% Used in the Stokrey learning rule
h = @(W,memVec,i,j) W(i,:)*memVec - W(i,i) * memVec(i) - W(i,j) * memVec(j);

% Note this is not done recursively since Matlab is not good at recursion
% For each memory
for idx = 1:size(memories,2)
    memVec = memories(:,idx);
    % Define the next iteration of the weigth matrix
    Wnew = W + (memVec'* memVec)/m;
    % Update each element Wnew(i,j) according to the rule
    for i = 1:n
        for j = 1:n
            Wnew = Wnew - (h(W,memVec,j,i) * memVec(i) + h(W,memVec,i,j) * memVec(j))/m;
        end
    end
    % Update the W matrix with the new values
    W = Wnew;
    image(W,'CDataMapping','scaled')
    title("Weight matrix")
    colorbar
end
    
    