% Returns the normalized irradiance function (G/q), which was derived from
% the analytical solution of the Radiative Transfer Equation (RTE).
%
% Inputs:
%   spec_coeffs: Attenuation coefficients. Order of Eabs, Esc, and b.
%   Cx: Biomass concentration in PBR (kg/m^3)
%   X: Reflectivity of outer wall coating
%   id: Inner diameter of annular design (cm)
%   od: Outer diameter of annular design (cm)
%
% Outputs:
%   G: Normalized irradiance function in terms of r [ro,R] (m).
%
% Sample Input:
%   irradiance([492.3334,3093.9,0.0063],0.5,0.51,1,3)
%
% Sample Output:
%   G(1/100/2) = 1.0221
%   G(3/100/2) = 0.1181
function G = irradiance(spec_coeffs, Cx, X, id, od)
    [a,d] = rte_params(spec_coeffs, Cx);
    
    % units from cm to m
    id = id/100;
    od = od/100;
    
    r_o = id/2; % inner tube
    R = od/2;
    L = R-r_o; % depth of culture
    G = irrad_fun(r_o,X,a,d,L);
end

%% Calculate Irradiance
% Normalized irradiance (G/q)
% Inputs:
%   r_o: radius of inner tube (m)
%   L: depth of culture (m)
%   X, a, d: same as defined initially
function G = irrad_fun(r_o,X,a,d,L)
    [num1,num2,den] = irrad_fun_params(X,a,d,L);
    G = @(r) 2.*(num1.*exp(d*(r-r_o))+num2.*exp(-d*(r-r_o)))./den;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%