function C_end = cell_growth(qo,spec_coeffs,X,d,D,u,V)
    global h
    h = 0.01; % (s)
    
    % initializing variables
    Cx_o = 10^-3;
    tau = residence_time(d,D,u,V);
    Ea = spec_coeffs(1);
    
    % store cell growth profile
    % ti Cx1
    Cx = Cx_o;
    cell_prof = [0 Cx];
    
    % initial values of irradiance_profile
    data = irradiance_profile(spec_coeffs,Cx,X,d,D,500,false);
    r = cell2mat(data{1}); G = cell2mat(data{2})*qo;
    
    % functions
    rx = @(Cx,G) mean_rxn_rate(Ea,Cx,r,G);
    dCxdt = @(Cx,G) rx(Cx,G) - Cx/tau;
    
    % iterate over i
    i = 1;
    
    while rx(Cx,G) > 0
        t = cell_prof(i,1); Cx = cell_prof(i,2);
        data = irradiance_profile(spec_coeffs,Cx,X,d,D,500,false);
        G = cell2mat(data{2})*qo;
        
        i = i + 1;
        cell_prof(i,:) = runge_kutta(dCxdt,G,Cx,t);
        
        if i > 10000
           break 
        end
    end
    
    C_end = cell_prof(end,2);
    C_end
end

function [t1, Cx1] = runge_kutta(fun,G,yi,ti)
    global h
    k1 = fun(yi,G);
    k2 = fun(yi+1/2*k1*h,G);
    k3 = fun(yi+1/2*k2*h,G);
    k4 = fun(yi+k3*h,G);
    Cx1 = yi + 1/6*(k1+2*k2+2*k3+k4)*h;
    t1 = ti + h;
end

function rx = mean_rxn_rate(Ea,Cx,r,G)
    rho_m = 0.8;
    phi = 1.83*10^-9; % kg/umole
    K = 90; % umole/m^2/s
    mu_s = 5*10^-3/3600; % /s
    
    % if G is greater than the saturated value
    %   - recall that increasing power above this point is futile in the
    %     sense that it does not increase the growth rate
    greater = G > 220;
    G(greater) = 220;
    
    A = 2*Cx/(r(end)^2-r(1)^2);
    B = rho_m*K*phi*Ea;
    C = -mu_s/2*(r(end)^2-r(1)^2);
    int = trapz(r,G./(K+G).*r);
    rx = A*(B*int+C);
end

function tau = residence_time(d,D,u,V)
    R = D/2/100;
    r = d/2/100;
    Q = pi*(R^2-r^2)*u;
    tau = V/Q;
end