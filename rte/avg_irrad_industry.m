% Calculates the irradiance of a cross-section for light attenuation of
% PBRs in industry (light hits tubular reactor at a 90 deg angle).
%
% Inputs:
%   qo:
%   spec_coeffs: Attenuation coefficients. Order of Eabs, Esc, and b.
%   Cx: Biomass concentration in PBR (kg/m^3)
%   X: Reflectivity of outer wall coating
%   od: Outer diameter of annular design (cm)
%
% Outputs:
%   G_avg: Irradiance for cross-section (mumol/m^2/s).
function G_avg = avg_irrad_industry(qo, spec_coeffs, Cx, X, od)
    % units from cm to m
    od = od/100;
    
    R = od/2;
    z = linspace(0+10^-5,R,100);
    theta1 = asin(z./R);
    %theta1 = linspace(0+pi/720,pi/2,100);
    
    L = @(r,t) 2*R*cos(asin(r/R.*sin(t)));
    xsi = @(r,t) L(r,t)/2 + r.*cos(t);
    
    int = 0;
    
    for i = 1:length(theta1)
        % more efficient to use logspace rather than linspace as the radius
        % would not be evenly spaced using linspace
        theta = logspace(log10(theta1(i)),log10(pi/2),100);
        %theta = linspace(theta1(i),pi/2,1800);
        L_v = L(R,theta1(i));
        Gq = irradiance(spec_coeffs,Cx,X,0,L_v*100*2);
        
        for j = 1:length(theta)
            r_pos = R*sin(theta1(i))./sin(theta);
            r_neg = R*sin(theta1(i))./sin(pi-theta);
            r = [xsi(r_neg,pi-theta) flip(xsi(r_pos,theta))]';
        end
        
        if i == 1
            int = int + trapz(r,Gq(r))*(z(i+1)-z(i));
        elseif i == length(theta1)
            int = int + trapz(r,Gq(r))*(z(i)-z(i-1));
        else
            int = int + trapz(r,Gq(r))*(z(i+1)-z(i-1))/2;
        end
    end
    
    G_avg = 2*qo*int;
end