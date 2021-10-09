classdef HopfieldNet
    
    properties
        N                           % Number of Neurons
        W                           % Weight matrix
        E                           % Energy array
        learningRule                % Hebbian/Storkey/Projection
        memories                    % Arrays of [1 -1]
        numOfMemories
        currentState                % States of neurons at any given step
        maxSteps = 100
    end
    
    methods
        function net = HopfieldNet(N, learningRule)
            % constructor
            net.N = N;
            net.W = zeros(N,N);
            net.learningRule = learningRule;
            net.currentState = zeros(N);
        end
        
        function net = hebbian(net)
            % Hebbian leaning for the weight matrix
            for idx = 1:net.numOfMemories
                memory = net.memories(idx,:);
                net.W = net.W + (memory' * memory);
            end
            net.W = net.W/net.N;
        end
        
        function net = strokey(net)
            % Storkey learning for the weight matrix
            for idx = 1:net.numOfMemories
                memory = net.memories(idx,:);
                
                % Compute components
                hebbian_term    = memory' * memory - eye(net.N);
                net_inputs = net.W * memory';
                pre_synaptic = memory' * net_inputs';
                post_synaptic = pre_synaptic';
    
                net.W = net.W + (hebbian_term - pre_synaptic - post_synaptic)/net.N;
            end
        end
        
        function net = projection(net)
             net = hebbian(net);
             net.W = pinv(net.W);
        end
        
        function net = train(net, memories)
            % Compures weight matrix according to the learning rule
            net.memories = memories;
            net.numOfMemories = size(net.memories,1);
            switch net.learningRule
                case 'Hebbian'
                    net = hebbian(net);
                case 'Storkey'
                    net = strokey(net);
                case 'Projection'
                    net = projection(net);
                otherwise
                    fprintf('Error, the leraning rule is not recognized!\n');
            end  
            net.W(boolean(eye(net.N))) = 0;  % Remove self connections 
        end
        
      
 
        function [reconstructedMemory, step] = reconstruct(net, inputMemory)
            % Reconstructs (possibly corrupted) memory, also returns
            % the number of needed steps
            net.currentState = inputMemory;        % Initialise the state
            for step=1:net.maxSteps
                newState = update(net);            % Update until no 
                if net.currentState == newState    % changes occur
                    break;
                else
                net.currentState = newState;
                end
            end
             reconstructedMemory = net.currentState;
        end
        
        function newState = update(net)
            % Update each neuron in a randomely generated sequence
            newState = net.currentState;
            randOrd = randperm(net.N);     % generate random node sequence
            for idx = 1:net.N
                dw = (net.W(randOrd(idx),:) * newState');
                if dw > 0
                    newState(randOrd(idx)) = 1;
                else
                    newState(randOrd(idx)) = -1;
                end
            end
        end
        
    end
end
