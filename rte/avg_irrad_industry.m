% Calculates the irradiance of a cross-section for light attenuation of
% PBRs in industry (light hits tubular reactor at a 90 deg angle).
%
% Inputs:
%   qo: Source light intensity (mumol/m^2/s) 
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
    
    % depth of culture
    L = @(t1) 2*R*cos(t1);
    % light travelled from [0,L] (m)
    xsi = @(t1,t) L(t1)/2 + R.*sin(t1)./sin(t).*cos(t);
    
    j = @(t1,t) sin(t1).*cos(t1)./(sin(t)).^2; % Jacobian
    % irradiance will change for each theta_1
    Gq = @(t1) irradiance(spec_coeffs,Cx,X,0,L(t1)*100*2);
    
    % integral bounds for theta
    tmax = @(t1) pi - t1;
    tmin = @(t1) t1;
    
    % integrand
    f = @(t1,t) feval(Gq(t1),xsi(t1,t)).*j(t1,t);
    
    int1 = integral2(f,0+10^-5,pi/2,pi/2,tmax);
    int2 = -integral2(f,0+10^-5,pi/2,tmin,pi/2);
    A = pi*od^2/4;
    G_avg = 2*qo*R^2/A*(int1+int2);
end

%% numerical solution
%     z = linspace(0+10^-5,R,100);
%     theta1 = asin(z./R);
%     %theta1 = linspace(0+pi/720,pi/2,100);
%     
%     L = @(r,t) 2*R*cos(asin(r/R.*sin(t)));
%     xsi = @(r,t) L(r,t)/2 + r.*cos(t);
%     
%     int = 0;
    
%     for i = 1:length(theta1)
%         % more efficient to use logspace rather than linspace as the radius
%         % would not be evenly spaced using linspace
%         theta = logspace(log10(theta1(i)),log10(pi/2),100);
%         %theta = linspace(theta1(i),pi/2,1800);
%         L_v = L(R,theta1(i));
%         Gq = irradiance(spec_coeffs,Cx,X,0,L_v*100*2);
%         
%         for j = 1:length(theta)
%             r_pos = R*sin(theta1(i))./sin(theta);
%             r_neg = R*sin(theta1(i))./sin(pi-theta);
%             r = [xsi(r_neg,pi-theta) flip(xsi(r_pos,theta))]';
%         end
%         
%         if i == 1
%             int = int + trapz(r,Gq(r))*(z(i+1)-z(i));
%         elseif i == length(theta1)
%             int = int + trapz(r,Gq(r))*(z(i)-z(i-1));
%         else
%             int = int + trapz(r,Gq(r))*(z(i+1)-z(i-1))/2;
%         end
%     end
%     
%     A = pi*od^2/4;
%     G_avg = 2*qo*int/A;