% calculate the imaginary refractive index which is dependent the
% wavelength of light
%
% light absorbance values from (Bidigare 1990)
%
% Inputs:
%   rho - density of dry cell mass (kg/m^3)
%   w - pigment weight fraction vector. Order of chlA, chlB, PPC
%   xw - water fraction of cell (optional input)
%
% Outputs:
%   k - imaginary refractive index across PAR
%
% Sample inputs (Clamydomonas reinhardtii)
% rho = 1400
% w = [1.4;0.7;0.45]
% xw = 0.78
% -- imaginary_refract(1400,[1.4;0.7;0.45]) --
function k = imaginary_refract(rho, w, xw)
    % check if xw is specified, otherwise...
    if nargin == 2
      xw = 0.78;
    end
    
    % Ea and wavelength
    load absorbance.mat % chloroA chloroB PPC
    w = w/100;
    
    % (matrix ops)*(scalar ops)
    k = (wavelength.*Ea*w)*10^-9/(4*pi)*rho*(1-xw)/xw;
end