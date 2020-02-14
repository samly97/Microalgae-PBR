% Calculates the average normalized irradiance.
%
% Inputs:
%   spec_coeffs: Attenuation coefficients. Order of Eabs, Esc, and b.
%   Cx: Biomass concentration in PBR (kg/m^3)
%   X: Reflectivity of outer wall coating
%   id: Inner diameter of annular design (cm)
%   od: Outer diameter of annular design (cm)
%
% Outputs:
%   G_avg: Normalized average irradiance.
%
% Sample Input:
%   average_irradiance([492.3334,3093.9,0.0063],0.5,0.51,1,3)
%
% Sample Output:
%   G_avg = 0.3135
function G_avg = average_irradiance(spec_coeffs, Cx, X, id, od)
    [a,d] = rte_params(spec_coeffs, Cx);
    
    % units from cm to m
    id = id/100;
    od = od/100;
    
    r_o = id/2; % inner tube
    R = od/2;
    
    G_avg = calc_avg_irrad(X,a,d,r_o,R);
end

function G_avg = calc_avg_irrad(X,a,d,r,R)
    L = R-r;
    [A,B,C] = irrad_fun_params(X,a,d,L);
    D = 4/C/(R^2-r^2);
    
    int1 = @(x) x/d*exp(d*(x-r))-exp(d*(x-r))/d^2; 
    int2 = @(x) exp(d*r)/d^2*(-d*exp(-d*x)*x-exp(-d*x));
    
    G_avg = D*(A*(int1(R)-int1(r))+B*(int2(R)-int2(r)));
end