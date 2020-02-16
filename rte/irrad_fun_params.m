% Calculates the numerator and denominator terms of the normalized
% irradiance equation. This is used for both the irradiance and average
% irradiance function.
%
% Inputs:
%   X: Reflectivity of outer wall coating
%   a: linear scattering modulus
%   d: two-flux extinction coefficient
%   L: depth of culture (m)
%
% Sample Input:
%   irrad_fun_params(0.51,0.9626,255.7268,0.01)
%
% Sample Output:
%   [A,B,C] = [0.0747, 25.0728, 49.2111]
function [num1,num2,den]= irrad_fun_params(X,a,d,L)
    num1 = calc_num1(X,a,d,L);
    num2 = calc_num2(X,a,d,L);
    den = calc_denom(X,a,d,L);
end

% Helper function: 1st term in numerator
function num1 = calc_num1(X,a,d,L)
    num1 = X.*(1+a).*exp(-d.*L);
    num1 = (num1 - (1-a).*exp(-d.*L));
end

% Helper Function: 1nd term in numerator
function num2 = calc_num2(X,a,d,L)
    num2 = (1+a).*exp(d.*L);
    num2 = (num2 - X.*(1-a).*exp(d.*L));
end

% Helper Function: Denominator
function den = calc_denom(X,a,d,L)
    den = (1+a).^2.*exp(d.*L);
    den = den -(1-a).^2.*exp(-d.*L);
    den = den -X.*(1-a.^2).*exp(d.*L);
    den = den + X.*(1-a.^2).*exp(-d.*L);
end