# beamformingConvexOptimizationProblem
A simple algorithm for creating and solving a beamforming optimization problem is considered.
The output of the beamformer network is tried to be recovered from the noise and interference in the channel.
A random noise is created, and it can be used for several comparison simulation from the given script. 
MATLAB CVX tool is used for solving the convex optimization problem.

Function computeOptimizationProblem.m has
Inputs
N (number of antenna), 
J (number of snapshots), 
n (created noise), 
eqn (formulation for the solution 4: known steering vector | 6: unknown steering vector, worst-case scenario approach)

Outputs
optimalValue: resulting optimal value found by CVX
snrValue: calculated signal-to-noise ratio for the optimized structure
iterNumber: number of CVX iterations
weightingCoef: resulting optimal beamforming coefficient values

beamforming_comparison.m File:
Creates the inputs and calls the function computeOptimizationProblem
Plots the results for different cases
