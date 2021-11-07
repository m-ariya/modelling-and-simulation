# Hopfield Network Simulation with Different Learning Rules
This repository contains the code for the Modelling and Simulation course.
## Description
Hopfield networks can be used to model associative memory and therefore, can serve as a tool for pattern recognition. However, a good balance between recognition accuracy and storage capacity is needed to build a robust system. In this study, we will investigate different learning rules for Hopfield networks and evaluate their performance in terms of noise tolerance and the amount of patterns that can be stored. Please refer to our report for the details.
## Instructions

 - The small interactive demo is available at
   

> modelling-and-simulation/demo.m
**It serves only for some visual idea of Hopfield networks dynamics, no results have been derived from this scipts for the report.**
Run the script in MATLAB environment, select the learning rule and pattern from drop-down list. Control the distortion level by moving a corresponding slider. The current level will be shown on the title of the figure. Press the "Reconstruct" button and wait until the algorithm is finished. The progress is reflected at the bottom indicating the step number. The neuron which is currently considered for the update will be highligted first. In the end the final Hamming distance will shown in the title. If it is 0, the pattern was reconstructed correctly.
   
 -  Two simulation scenarios **on which we base our study** are available at
  

>  modelling-and-simulation/Matlab/simulations/robustness.m

and
   

> modelling-and-simulation/Matlab/simulations/capacity.m
(Note, it takes some time until you see final results)


