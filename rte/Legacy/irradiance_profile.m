%% Legacy
% Do not use - only for reference

% Calculates the normalized irradiance profile (G/q) from the analytical
% solution of the Radiative Transfer Equation (RTE).
%
% Inputs:
%   spec_coeffs: Attenuation coefficients. Order of Eabs, Esc, and b.
%   Cx: Biomass concentration in PBR (kg/m^3)
%   X: Reflectivity of outer wall coating
%   id: Inner diameter of annular design (cm)
%   od: Outer diameter of annular design (cm)
%   n: number of points between r to R
%   contour: 'true' or 'false' to plot contour
%
% Outputs:
%   data: 1x3 cell of r, G, and G_avg
%
% Sample Inputs:
%   X = 0.51 (Stainless steel)
%
% Future Support:
%   Consider the diameter of the light source, so distance will be
%   effectively reduced
function data = irradiance_profile(spec_coeffs, Cx, X, id, od, n, contour)
    Ea = spec_coeffs(1); Esc = spec_coeffs(2); b = spec_coeffs(3);
    a = calc_lin_scatter(Ea,Esc,b);
    d = calc_delta(Ea,Esc,b,Cx);
    
    % units from cm to m
    id = id/100;
    od = od/100;
    
    r_o = id/2; % inner tube
    R = od/2;
    L = R-r_o; % depth of culture
    
    r = linspace(r_o,R,n);
    G = calc_irrad(r,r_o,X,a,d,L);
    G_avg = calc_avg_irrad(X,a,d,r_o,R);
    
    % from array to cell to make storable
    r = mat2cell(r,1); G = mat2cell(G,1); G_avg = mat2cell(G_avg,1);
    data = {r,G,G_avg};
    
    if contour == true
        irradiance_contour(r_o,R,Cx,X,a,d,L,n)
    end
end

%% Plot Contour
function irradiance_contour(r_o,R,Cx,X,a,d,L,n)
    theta = linspace(0,2*pi,n);
    r = linspace(r_o,R,n)';
    x = r.*sin(theta);
    y = r.*cos(theta);
    z = calc_irrad(sqrt(x.^2+y.^2),r_o,X,a,d,L);
    contour(x,y,z)
    legend(num2str(z(ceil(linspace(1,n,5))',1)))
    file_loc = sprintf('%s/%.4f_(cm)-%.4f_(cm)-%.2f_(kg m3)-contour.png', ...
        results, r_o*2*100, R*2*100, Cx);
    saveas(gcf,file_loc)
    close(gcf)
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Calculate Irradiance
% Normalized irradiance (G/q)
% Inputs:
%   r: evenly spaced distance from r to R (m)
%   r_o: radius of inner tube (m)
%   L: depth of culture (m)
%   X, a, d: same as defined initially
function G = calc_irrad(r,r_o,X,a,d,L)
    num1 = calc_num1(X,a,d,L);
    num2 = calc_num2(X,a,d,L);
    G = 2.*(num1.*exp(d*(r-r_o))+num2.*exp(-d*(r-r_o)))./calc_denom(X,a,d,L);
end

% Calculate average normalized irradiance (G/q)avg
% Inputs:
%   r: radius of inner tube (m)
%   R: radius of outer tube (m)
%   X, a, d: same as defined initially
function G_avg = calc_avg_irrad(X,a,d,r,R)
    L = R-r;
    A = calc_num1(X,a,d,L);
    B = calc_num2(X,a,d,L);
    C = calc_denom(X,a,d,L);
    D = 4/C/(R^2-r^2);
    
    int1 = @(x) x/d*exp(d*(x-r))-exp(d*(x-r))/d^2; 
    int2 = @(x) exp(d*r)/d^2*(-d*exp(-d*x)*x-exp(-d*x));
    
    G_avg = D*(A*(int1(R)-int1(r))+B*(int2(R)-int2(r)));
end

% Helper function: 1st term in numerator
function num1 = calc_num1(X,a,d,L)
    num1 = X*(1+a)*exp(-d*L);
    num1 = (num1 - (1-a)*exp(-d*L));
end

% Helper Function: 1nd term in numerator
function num2 = calc_num2(X,a,d,L)
    num2 = (1+a)*exp(d*L);
    num2 = (num2 - X*(1-a)*exp(d*L));
end

% Helper Function: Denominator
function den = calc_denom(X,a,d,L)
    den = (1+a)^2*exp(d*L);
    den = den -(1-a)^2*exp(-d*L);
    den = den -X*(1-a^2)*exp(d*L);
    den = den + X*(1-a^2)*exp(-d*L);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Calculate Parameters
function a = calc_lin_scatter(Ea,Esc,b)
    a = sqrt(Ea/(Ea+2*b*Esc));
end

function d = calc_delta(Ea,Esc,b,Cx)
    d = Cx*sqrt(Ea*(Ea+2*b*Esc));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Save Results
% Project is being called from the master folder 'PBR Model', so results
% will be saved in 'PBR Model'/Results/'RTE Contour'
function folder = results
    % will return project folder since is called from there
    Project = pwd; 
    folder = sprintf('%s/Results/RTE Contour',Project);
end