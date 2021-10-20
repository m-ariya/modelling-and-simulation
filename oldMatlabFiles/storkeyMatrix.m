function new_weigths = storkeyMatrix(memory,old_weights)
% memory : fatt memory vector
% old_weights : nxn vector of current weigths
% new_weigths : updated weigth matrix with the new memory
% https://stats.stackexchange.com/questions/276889/whats-wrong-with-my-algorithm-for-implementing-the-storkey-learning-rule-for-ho

    % Find the size of the memory
    n = size(memory,1);
    
    % See if previous_weights where provided
    if (nargin == 1)
        old_weights = zeros(n);
    end
    
    % Compute components 
    hebbian_term    = memory' * memory - eye(n);
    
    net_inputs      = old_weights * memory';
    pre_synaptic    = memory' * net_inputs';
    post_synaptic   = pre_synaptic';
    
    new_weigths     = old_weights + (hebbian_term - pre_synaptic - post_synaptic)/n;
end

