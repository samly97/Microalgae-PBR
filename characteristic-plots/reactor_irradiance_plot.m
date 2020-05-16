% Plots the percent of irradiance over source irradiance. This is a visual
% tool to diagnose when microalgae growth will stop.
%
% Inputs:
%   Gc - Minimum irradiance for growth (mumol/m^2/s)
%   qo - Source light intensity (mumol/m^2/s)
%   X - Reflectivity of reactor coating
%   ID - Inner diameter of annulus (cm)
%   OD - Outer diameter of annulus (cm)
%   spec_coeff - Attenuation coefficients. Order of Eabs, Esc, and b.
%   Cx_end - Plot from 10^-5 to this concentration
%   n - number of values in plot
function reactor_irradiance_plot(Gc,qo,X,ID,OD,spec_coeff,Cx_end,n)
    r = ID/100/2; % inner annular radius (m)
    R = OD/100/2; % outer annular radius (m)
    
    Cx = linspace(10^-5,Cx_end,n)'; % array from Cx_o to Cx_end
    data = zeros(n,1);
    
    % note - should probably look into vectorizing the below
    for i = 1:n
        Gq = irradiance(spec_coeff,Cx(i),X,ID,OD);
        R_d = r_dark(qo,Gq,r,R);
        f_illum = (R_d^2 - r^2)/(R^2 - r^2)*100;
        data(i) = f_illum;
    end
    
    plot(Cx,Gc/qo*100*ones(n,1), 'k')
    hold on
    plot(Cx,data)
    legend('Compensation Irradiance')
    ylabel('% Illumination')
    xlabel('Microalgae Concentration (kg m^-^3)')
end