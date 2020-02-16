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

% [z,Cx] = cell_kinetics(0.025,0.4,220,spec_coeff,0.51,3.175,10.4775);

% % Permutations of pipes
pipes = get_pipes(0.125);
data = sensitivity_test(220, spec_coeff, 0.51, 0.125);

% Future Tasks:
%   - need to account for irradiance (W/m^2) to micro-mole conversion
%   > http://www.egc.com/useful_info_lighting.php
%   - for now, assume everything is qo = 220 micro-mol/m^2/s

% Issues:
%   - irradiance_profile.m rethink logic - done
%   - geometry_sim.m affected by above - W doesn't look correct - fixed

% Completed:
%   - need to account for inverse square law - done