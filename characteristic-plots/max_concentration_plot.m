% Visually determine the maximum concentration of microalgae cultivatable
% for a given set of: qo, ID, and OD.
%
% Inputs:
%   qo - Source light intensity (mumol/m^2/s)
%   X - Reflectivity of reactor coating
%   ID - Inner diameter of annulus (cm)
%   OD - Outer diameter of annulus (cm)
%   spec_coeff - Attenuation coefficients. Order of Eabs, Esc, and b.
%   L_o - Start plot from this reactor length (m)
%   L_f - End plot at this reactor length (m)
%   n - number of values in plot
function max_concentration_plot(qo,X,ID,OD,spec_coeff,L_o,L_f,n)
    L = logspace(log10(L_o),log10(L_f),n);
    data = zeros([n 1]);

    for i = 1:length(L)
        u = 0.01;
        D = u/L(i)*24*3600; 
        [z,Cx] = cell_kinetics(u,D,qo,spec_coeff,X,ID,OD,0.01);
        data(i) = Cx(end); 
        %data(i) = max(Cx);
    end

    plot(L,data)
    ylabel('Microalgae Concentration (kg m^-^3)')
    xlabel('Reactor Length (m)')
end