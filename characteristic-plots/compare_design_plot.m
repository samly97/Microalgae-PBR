% Plots the average light intensity as a function of microalgae
% concentration. The annular design is plot against a 'traditional design'.
%
% Inputs:
%   qo - Source light intensity (mumol/m^2/s)
%   X - Reflectivity of reactor coating
%   ID - Inner diameter of annulus (cm)
%   OD - Outer diameter of annulus (cm)
%   spec_coeff - Attenuation coefficients. Order of Eabs, Esc, and b.
%   Cx_end - Plot from 0.01 to this concentration
%   n - number of values in plot
function compare_design_plot(qo,X,ID,OD,spec_coeff,Cx_end,n)
    Cx = linspace(0.01,Cx_end,n);
    data = zeros([n 2]);
    
    for i=1:n
        G_avg_ann = qo*average_irradiance(spec_coeff, Cx(i), X, ID, OD);
        G_avg_ind = avg_irrad_industry(qo, spec_coeff, Cx(i), X, OD);
        data(i,:) = [G_avg_ann G_avg_ind];
    end

    plot(Cx,data)
    legend('Annular','Traditional')
    ylabel('Average Irradiance(\mumol m^-^2 s^-^1)')
    xlabel('Microalgae Concentration (kg m^-^3)')
end