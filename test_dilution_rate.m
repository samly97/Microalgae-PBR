% Calculates the volumetric productivity of the given u,D arrays. The
% optimal configuration maximizes the productivity.
%
% Inputs:
%   L - length of photobioreactor (m)
%   D_o - initial dilution rate (1/day)
%   D_f - final dilution rate (1/day)
%   Mx_r - microalgae from recycle stream (by dry cells) (kg/day)
%   Qx_req - microalgae required for 'X' throughput (by dry cells) (kg/day)
%   X - reflectivity of outer diameter coating
%   ID - inner diameter of reactor (cm)
%   OD - outer diameter of reactor (cm)
%   spec_coeffs - spectral coefficients from Lorenz-Mie
%
% Outputs:
%   data - columns in order of: u, D, Cxro, % illum, Cxf
function data = test_dilution_rate(L,D_o,D_f,Mx_r,Qx_req,X,ID,OD,spec_coeffs)
    D = logspace(log10(D_o),log10(D_f),10);
    %D = linspace(D_o,D_f,25);
    data = zeros([length(D) 5]);
    Cx_r_o = 0.01;
    
    for i = 1:length(D)
        u = L*D(i)/24/3600; 
        err = 69;

        while err > 0.01
            [z,Cx] = cell_kinetics(u,D(i),220,spec_coeffs,X,ID,OD,Cx_r_o);
            Cx_f = Cx(end);

            Q = pi*((OD/100/2)^2-(ID/100/2)^2)*u;
            Qx = Q*Cx_f;
            Qx = Qx*3600*24; % in kg/day
            n = Qx_req/Qx; % number of reactors required
            Q_pbr = Q*n*3600; % total flowrate from PBRs (m^3/h)

            err = abs((Q_pbr*Cx_r_o-(Mx_r/24))/(Mx_r/24))*100;
            Cx_r_o = (Mx_r/24)/Q_pbr;
        end

        Gq = irradiance(spec_coeffs,Cx_f,X,ID,OD); % norm'd irrad func
        % fractional illumination
        R_d = r_dark(220,Gq,ID/100/2,OD/100/2);
        f_illum = (R_d^2 - (ID/100/2)^2)/((OD/100/2)^2 - (ID/100/2)^2);

        data(i,:) = [u D(i) Cx_r_o f_illum Cx_f];
        disp(i)
    end
end