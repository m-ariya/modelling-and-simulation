clear all;
rng(123);
%% ------ Load input ------
% load memories and memoryNames
load('Matlab/input/randomPatterns.mat')
[m, n] = size(memories);

%% ------ Instantiate models ------
hebiNet = HopfieldNet(n, 'Hebbian');
storNet = HopfieldNet(n, 'Storkey');
projNet = HopfieldNet(n, 'Projection');

%% ------ Define simulation parameters ------
iterations = 10;
distortionLevel = 20;
capacities = [1:100];

%% ------ Run simulation ------
hebiOutput = capacityFunc(hebiNet, iterations, distortionLevel, capacities, memories);
storOutput = capacityFunc(storNet, iterations, distortionLevel, capacities, memories);
projOutput = capacityFunc(projNet, iterations, distortionLevel, capacities, memories);

%% ------ Accuracy annalysis plotting ------
plot(capacities, hebiOutput,'LineWidth', 1.5, 'DisplayName','Hebbian')
hold on
plot(capacities, storOutput, 'LineWidth',1.5, 'DisplayName','Storkey')
hold on
plot(capacities, projOutput, 'LineWidth',1.5, 'DisplayName','Pseudo-inverse');
hold on

% Plot theoretical limits
hebiLim = n/(2*log2(n));
storLim = n/(sqrt(2*log2(n)));
projLim = n;
xline(hebiLim, '-.','Hebbian limit', 'HandleVisibility','off')
xline(storLim, '-.', 'Storkey limit', 'HandleVisibility','off');
xline(projLim, '-.', 'Pseudo-inverse limit', 'HandleVisibility','off');

xlabel('Number  of stored patterns') 
ylabel('Accuracy') 

title(['Accuracy vs Capacity with distortion level=',num2str(distortionLevel)])
ylim([0,1])
grid on
grid minor
legend()

