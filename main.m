% Find paths
Project_Folder = pwd;
Bhmie = sprintf('%s/bhmie-matlab',Project_Folder);
RTE = sprintf('%s/rte',Project_Folder);
Sensitivity = sprintf('%s/sensitivity',Project_Folder);
Reactor = sprintf('%s/reactor',Project_Folder);

% Add dependencies
addpath(genpath(Bhmie))
addpath(genpath(RTE))
addpath(genpath(Sensitivity))
addpath(genpath(Reactor))

% Spectral values for RTE Equation
spec_coeff = ...
    atten_coefficients(100,3.2*10^-6,1.16,1400,[4;1;1.6],'N. Oleoabundans',false);

% Permutations of pipes
pipes = get_pipes(0.125);
data = sensitivity_test(220, spec_coeff, 0.51, 0.125);

% Debug cell kinetics:
% [z,Cx] = cell_kinetics(0.025,0.4,220,spec_coeff,0.51,3.175,10.4775);