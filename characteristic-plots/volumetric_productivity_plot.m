% Plots the volumetric productivity against the dilution rate. This graph
% is used to determine the optimal dilution rate for operation. 
%
% Inputs:
%   D - Vector of dilution rate (1/day)
%   Cx_f - Vector of outlet microalgae (kg/m^3)
%   xw - Water volume fraction of microalgae species
function volumetric_productivity_plot(D,Cx_f,xw)
    vx = D.*Cx_f/(1-xw); % volumetric productivity
    plot(D,vx)
    ylabel('Volumetric Productivity (kg m^-^3 day^-^1)')
    xlabel('Dilution Rate (day^-^1)')
end