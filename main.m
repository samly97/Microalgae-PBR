% Set paths
Project_Folder = pwd;
Bhmie = sprintf('%s/bhmie-matlab',Project_Folder);
RTE = sprintf('%s/rte',Project_Folder);
Sensitivity = sprintf('%s/sensitivity',Project_Folder);
Reactor = sprintf('%s/reactor',Project_Folder);
Plots = sprintf('%s/characteristic-plots',Project_Folder);

% Add dependencies
addpath(genpath(Bhmie))
addpath(genpath(RTE))
addpath(genpath(Sensitivity))
addpath(genpath(Reactor))
addpath(genpath(Plots))

%% Spectral values for RTE Equation
spec_coeff = ...
    atten_coefficients(100,3.2*10^-6,1.16,1400,[4;1;1.6],'N. Oleoabundans',false);

%% Reactor specifications and recycle stream data
X = 0.945;
ID = 4.7625; 
OD = 27.6225;
L = 5000;
Mx_r = 1022.0112; % dry microalgae recycle (kg/day)
Qx_req = 4667.653521; % dry microalgae required (kg/day)
qo = 220; % light source intensity (mumol/m^2/s)

%% sensitivity analysis
%data = sensitivity_test(220, spec_coeff, X, 0.125);

%% find u,D which minimizes costs
% data = test_dilution_rate(L,0.6,2,Mx_r,Qx_req,X,ID,OD,spec_coeff);
% D = data(:,2); Cx_f = data(:,5);
% volumetric_productivity_plot(D,Cx_f,0.78)

%% Percent Illumination Plot
% Gc = 15; Cx_end = 0.35; n = 100;
% reactor_irradiance_plot(Gc,qo,X,ID,OD,spec_coeff,Cx_end,n)

%% Comparison between annular and traditional design
% Cx_end = 0.063462956; n = 100;
% compare_design_plot(qo,X,ID,OD,spec_coeff,Cx_end,n)

%% Maximum possible concentration
L_o = 10; L_f = 10^6; n = 50;
max_concentration_plot(qo,X,ID,OD,spec_coeff,L_o,L_f,n)