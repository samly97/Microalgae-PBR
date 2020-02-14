% Calculates the sauter volume, V32, which is a measurement associated with
% fluid dynamics. It measures an equivalent volume/surface ratio if the
% particle acts like a bubble.
%
% Inputs:
%   d - mean microalgae diameter (m)
%   sigma - std. dev. of log normal distribution
%
% Ouputs:
%   V32 - sauter volume (m^3)
%
% Sample inputs (Clamydomonas reinhardtii)
% d = 7.98
% sigma = 1.17
% -- sauter(7.98*10^-6, 1.17) --
% Sample Inputs (Neochloris Oleoabundans)
% d = 3.2
% sigma = 1.16
% -- sauter(3.2*10^-6, 1.16) --

% Sample outputs
%   C. reinhardtii: V32 = 3.2011e-16
%   N. oleoabundans: V32 = 2.0240e-17

function V32 = sauter(d, sigma)
    lnd_sa = log(d) + log(sigma)^2;
    lnd_v = log(d) + 1.5*log(sigma)^2;
    d_sa = exp(lnd_sa);
    d_v = exp(lnd_v);
    
    % Vp/Ap
    d_32 = (d_v/2)^3/(3*(d_sa/2)^2)*6;
    V32 = 4/3*pi*(d_32/2)^3;
end