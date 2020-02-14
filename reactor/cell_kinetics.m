% Returns the concentration profile (Cx vs. L) for a given fluid velocity,
% dilution rate, reflectivity, and PBR geometry.
%
% Inputs:
%   u: flow velocity (m/s)
%   D: Dilution rate (1/day)
%   qo: source irradiance (umole/m^2/s)
%   spec_coeffs: Attenuation coefficients. Order of Eabs, Esc, and b.
%   X: Reflectivity of outer wall coating
%   id: Inner diameter of annular design (cm)
%   od: Outer diameter of annular design (cm)
%
% Outputs:
%   z: reactor length profile (m)
%   Cx: dry-cell microalgae concentration profile (kg/m^3)
function [z,Cx] = cell_kinetics(u,D,qo,spec_coeffs,X,id,od)
    global r_o R q
    r_o = id/100/2;
    R = od/100/2;
    A = reactor_area(r_o,R);
    q = u*A; % volumetric flowrate (m^3/s)
    
    L = reactor_length(u,D);
    z_span = [0 L];
    Cx_o = 10^-3;
    [z,Cx] = ode45(@(z,Cx) dCxdz(z,Cx,qo,spec_coeffs,X),z_span,Cx_o);
end

% PBR plug flow design equation
function f = dCxdz(z,Cx,qo,spec_coeffs,X)
    global r_o R q
    [rho_m,phi,K,mu_s] = get_rxn_params();
    
    % Normalized irradiance
    G_q = irradiance(spec_coeffs, Cx, X, r_o*100*2, R*100*2);
    
    % illumination fraction
    R_c = r_dark(qo,G_q,r_o,R);
    f_ill = (R_c^2-r_o^2)/(R^2-r_o^2);
    
    E_abs = spec_coeffs(1); % absorption efficiency
    G = @(r) (G_q(r)/G_q(r_o))*qo; % irradiance
    r_span = linspace(r_o,R,500);
    
    f = (2*pi*f_ill*Cx)/q*(rho_m*phi*K*E_abs* ...
        trapz(r_span,G(r_span)./(K+G(r_span)).*r_span) - mu_s/2*(R^2-r_o^2));
end

% cross-sectional area of reactor (m^2)
function A = reactor_area(r,R)
    A = pi*(R^2-r^2);
end

% total length required (m)
function L = reactor_length(u,D)
    L = u/D*24*3600;
end

% Get reaction parameters
function [rho_m,phi,K,mu_s] = get_rxn_params()
    % reaction rate params
    rho_m = 0.8;
    phi = 1.83*10^-9; % kg/umole
    K = 90; % umole/m^2/s
    mu_s = 5*10^-3/3600; % /s
end