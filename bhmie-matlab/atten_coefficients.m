% Calculates the spectral averaged attenuation coefficients and saves plot
% of the coefficients over the PAR.
%
% Inputs:
%   nang - internal Mie input, number of angles
%   d - mean microalgae diameter (m)
%   sigma - std. dev. of log normal distribution
%   rho - density of dry cell mass (kg/m^3)
%   w - pigment weight fraction vector. Order of chlA, chlB, PPC
%   label - Microalgae name; used to label documents
%   save_ouputs: true or false; forego plotting and csv files
%
% Sample inputs (Clamydomonas reinhardtii)
% nang = 100 (though this is not specific to microalgae)
% d = 7.98*10^-6
% sigma = 1.16
% rho = 1400
% w = [1.4;0.7;0.45]
% xw = C. Reinhardtii
% save_outputs = true

% -- atten_coefficients(100,7.98*10^-6,1.17,1400,[1.4;0.7;0.45], 'C. Reinhardtii', false) --
% Sample inputs (Neochloris oleoabundans)
% -- atten_coefficients(100,3.2*10^-6,1.16,1400,[4;1;1.6], 'N. Oleoabundans', true) --
%
% Sample outputs
%   C. reinhardtii: [178.504426404032,938.248866000028,0.0152387449543059]
%   N. oleoabundans: [492.333441701386,3093.94994189157,0.00631597107336615]
function coefficients = atten_coefficients(nang, d, sigma, rho, w, label, save_outputs)
    % Assume that xw is an interspecies constant
%     % check if xw is specified, otherwise...
%     if nargin == 6
%       xw = 0.78;
%     end
    xw = 0.78;

    % get microalgal parameters
    k = imaginary_refract(rho,w,xw);
    V32 = sauter(d,sigma);
    wave = linspace(400,700,151)';
    
    % calculating Mie inputs
    % 1.33 - ref. ind. of water
    [m,x] = calc_mie_inputs(1.527,1.33,d,wave,k);
    
    % Apply Mie Code
    [S1,S2,qext_PAR,qsca_PAR,b_PAR,g_PAR]= ...
        arrayfun(@mie,x,m,nang*ones(length(wave),1),'UniformOutput',false);
    % cell array to matrices
    qext_PAR=cell2mat(qext_PAR); qsca_PAR=cell2mat(qsca_PAR);
    
    % calculate b_PAR according to Pottier 2005
    b_PAR = calc_backscatter(S1,S2,qsca_PAR,x,nang);

    % calculating atten. coeffs. across the PAR
    [Ea_PAR,Esc_PAR] = calc_atten_coeffs(qext_PAR,qsca_PAR,d,V32,rho,xw);
    
    % calculating outputs (spectral averaged)
    [Ea,Esc,b] = calc_spectral(Ea_PAR,Esc_PAR,b_PAR,wave);
    coefficients = [Ea, Esc, b];
    
    if save_outputs == false
        return
    end
    
    folder = results;
    folder_p = sprintf('%s/Spectral Figures',folder);
    % plots
    plot_absorption(wave,Ea_PAR,Esc_PAR,folder_p,label)
    plot_backscatter(wave,b_PAR,folder_p,label)
    
    % save calculated values
    data = [wave k Ea_PAR Esc_PAR b_PAR];
    data = array2table(data);
    data.Properties.VariableNames(1:5) = {'wavelength', ...
        'k','E_abs','E_sca','b'};
    writetable(data,sprintf('%s/%s-mie_results.csv',folder,label));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Calculations

% Inputs:
%   n_m: microalgae absorptive index
%   n_e: absorptive index of environment
%   d: diameter of microalgae
%   wave: wavelength across PAR
%   k: imaginary index
% Outputs:
%   m: complex refractive index
%   x: size parameter
function [m,x] = calc_mie_inputs(n_m,n_e,d,wave,k)
    m = complex(n_m/n_e,k); % 1.33 - ref. ind. of water
    x = pi*d./(wave*10^-9);
end

% calculates the backscatter efficiency according to Pottier 2005
% unfortunately it seems Matlab does not allow vectorization on cell
% arrays
function b_PAR = calc_backscatter(S1,S2,qsca_PAR,x,nang)
    b_PAR = qsca_PAR;
    for i = 1:length(qsca_PAR)
       % calculate backscatter efficiency
       s1 = S1{i}(nang:end);
       s2 = S2{i}(nang:end);
       pi_list = linspace(pi/2,pi,100);
       % phase scattering function
       fun = (abs(s1).^2 + abs(s2).^2).*sin(pi_list)/2;
       norm = 4/(pi*x(i)^2*qsca_PAR(i));
       % integrate from pi/2 to pi
       b_PAR(i) = trapz(pi_list,fun)*norm;
    end
end

% calculates the attenuation coefficients Eabs and Esca
function [Ea_PAR,Esc_PAR] = calc_atten_coeffs(qext_PAR,qsca_PAR,d,V32,rho,xw)
    qabs_PAR = qext_PAR - qsca_PAR;
    Cabs = qabs_PAR*pi*(d/2)^2;
    Csc = qsca_PAR*pi*(d/2)^2;
    Ea_PAR = Cabs/(V32*rho*(1-xw));
    Esc_PAR = Csc/(V32*rho*(1-xw));
end

function [Ea,Esc,b] = calc_spectral(Ea_PAR,Esc_PAR,b_PAR,wave)
    Ea = trapz(wave,Ea_PAR)/300;
    Esc = trapz(wave,Esc_PAR)/300;
    b = trapz(wave,b_PAR)/300;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Plot
% Code for plotting absorption and backscatter.
% Each are saved in their own separate file.
% 
% Future support:
%   - formatting
function plot_absorption(wave,Ea_PAR,Esc_PAR,folder,label)
    % Eabs and Esc in PAR
    plot(wave,Ea_PAR)
    hold on
    plot(wave,Esc_PAR)
    legend('Absorption Efficiency','Scattering Efficiency')
    xlabel('Wavelength (nm)')
    ylabel('Spectral Efficiencies (m^2 kg^-^1)')
    file_loc = sprintf('%s/%s - Spec Eff vs. Wavelength.png', ...
        folder,label);
    saveas(gcf,file_loc)
    close(gcf)
end

function plot_backscatter(wave,b_PAR,folder,label)
    % backscatter in PAR
    plot(wave,b_PAR)
    xlabel('Wavelength (nm)')
    ylabel('Backscatter Efficiency')
    file_loc = sprintf('%s/%s - Backscatter vs. Wavelength.png', ...
        folder,label);
    saveas(gcf,file_loc)
    close(gcf)
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Save Results
% Project is being called from the master folder 'PBR Model', so plots will
% be saved in 'PBR Model'/Results/'Lorenz Mie Scattering'
function folder = results
    % will return project folder since is called from there
    Project = pwd; 
    folder = sprintf('%s/Results/Lorenz Mie Scattering',Project);
end