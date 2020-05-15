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

X = 0.945;
ID = 4.7625; 
OD = 27.6225;
L = 5000;
Mx_r = 1022.0112; % dry microalgae recycle (kg/day)
Qx_req = 4667.653521; % dry microalgae required (kg/day)

% sensitivity analysis
%data = sensitivity_test(220, spec_coeff, X, 0.125);

% find u,D which minimizes costs
% data = test_dilution_rate(L,0.6,5,Mx_r,Qx_req,X,ID,OD,spec_coeff);

% data = test_dilution_rate(L,0.6,2.25,Mx_r,Qx_req,X,ID,OD,spec_coeff);
% plot(data(:,2),data(:,2).*data(:,5)/0.2)

% Plots
Cx = linspace(0.01,0.35,100);
data = zeros([100 1]);

% Percent Illumination Plot
% for i=1:length(Cx)
%     Gq = irradiance(spec_coeff,Cx(i),X,ID,OD);
%     R_d = r_dark(220,Gq,ID/100/2,OD/100/2);
%     f_illum = (R_d^2 - (ID/100/2)^2)/((OD/100/2)^2 - (ID/100/2)^2)*100;
%     data(i) = f_illum;
% end
% 
% plot(Cx,data)

% Comparison between annular and traditional design
Cx = linspace(0.01,0.063462956,100);
data = zeros([100 2]);
for i=1:length(Cx)
   G_avg_ann = 220*average_irradiance(spec_coeff, Cx(i), X, ID, OD);
   G_avg_ind = avg_irrad_industry(220, spec_coeff, Cx(i), X, OD);
   
   data(i,:) = [G_avg_ann G_avg_ind];
end

plot(Cx,data)

% Maximum possible concentration
L = logspace(log10(10),log10(10^6),50);
data = zeros([50 1]);

for i = 1:length(L)
    u = 0.01;
    D = u/L(i)*24*3600; 
    [z,Cx] = cell_kinetics(u,D,220,spec_coeff,X,ID,OD,0.01);
    data(i) = Cx(end); 
    %data(i) = max(Cx);
end

plot(L,data)