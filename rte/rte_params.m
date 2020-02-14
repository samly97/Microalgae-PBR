% Returns the Radiative Transfer Equation parameters: the linear scattering
% modulus, a, and the two-flux extinction coefficient, d.
%
% Inputs:
%   spec_coeffs: Attenuation coefficients. Order of Eabs, Esc, and b.
%   Cx: Biomass concentration in PBR (kg/m^3)
%
% Outputs:
%   a: linear scattering modulus
%   d: two-flux extinction coefficient
%
% Sample Input:
%   rte_params([492.3334,3093.9,0.0063],0.5)
%
% Sample Output:
%   [a,d] = [0.9626, 255.7268]
function [a,d] = rte_params(spec_coeffs, Cx)
    Ea = spec_coeffs(1); Esc = spec_coeffs(2); b = spec_coeffs(3);
    a = calc_lin_scatter(Ea,Esc,b);
    d = calc_delta(Ea,Esc,b,Cx);
end

function a = calc_lin_scatter(Ea,Esc,b)
    a = sqrt(Ea/(Ea+2*b*Esc));
end

function d = calc_delta(Ea,Esc,b,Cx)
    d = Cx*sqrt(Ea*(Ea+2*b*Esc));
end