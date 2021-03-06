function data = sensitivity_test(qo, spec_coeffs, X, thickness)
    pipes = get_pipes(thickness);
    tests = test_cases(pipes);
    
    % d D G_avg_f_ind frac_illum G_avg_f Cx_final Cx_avg
    data = zeros(size(tests,1),7);
    for i=1:size(tests,1)
        d = tests(i,1);
        D = tests(i,2);
        
        % sometimes the outer diameter of the inner tube would be the same
        % size as the inner diameter of the outer tube... this is a lazy
        % way to skip
        if round(d,2)-round(D,2) == 0
            continue
        end
        
        % note: only fails at Cx_f and f_illum
        
        % final dry-weight microalgae concentration (kg/m^3)
        [z,Cx] = cell_kinetics(2000*1.5/24/3600,1.5,qo,spec_coeffs,X,d,D,0.01);
        Cx_f = Cx(end);
        Cx_avg = trapz(z,Cx)/z(end);
            
        % average irradiance
        Gq_avg_f = average_irradiance(spec_coeffs,Cx_f,X,d,D); % norm'd
        Gq = irradiance(spec_coeffs,Cx_f,X,d,D); % norm'd irrad func
        % initial value, Gq(r_o)
        Gq_avg = qo*Gq_avg_f/Gq(d/100/2); % normalized irradiance
        
        G_ind = avg_irrad_industry(qo,spec_coeffs,Cx_f,0,D);
        
        % fractional illumination
        R_d = r_dark(qo,Gq,d/100/2,D/100/2);
        f_illum = (R_d^2 - (d/100/2)^2)/((D/100/2)^2 - (d/100/2)^2);
       
        data(i,:) = [d D G_ind f_illum Gq_avg Cx_f Cx_avg];
        
        disp(i)
    end
    folder = results;
    data = array2table(data);
    data.Properties.VariableNames(1:7) = {'d','D','G_ind','f_illum','G_avg','Cx_f','Cx_avg'};
    writetable(data,sprintf('%s/sensitivity_test.csv',folder));
end

%% Get Test Cases
% Create data to run irradiance test at
% Logic:
%   Start with smallest pipe diameter size and then consider all
%   combinations of pipes which are bigger. Thus the end array will be of
%   size:
%       (n-1)+(n-2) + ... + 1
% Output:
%   inner, outer
function data = test_cases(pipes)
    n = size(pipes,1);
    [m,ind] = data_dim(n);
    data = zeros(m,2);
    % important diameters:
    %   col 1: inner tube - OD
    %   col 2: outer tube - ID
    for j=1:length(ind)+1
        if j==1
            inner = pipes(1,2)*ones(length(1:ind(j)),1);
            data(1:ind(j),:) = [inner pipes(j+1:n,1)];
            continue
        end
        
        if j==length(ind)+1
            inner = pipes(j,2);
            data(ind(j-1)+1,:) = [inner pipes(j+1,1)];
            continue
        end
        
        inner = pipes(j,2)*ones(length(ind(j-1)+1:ind(j)),1);
        data(ind(j-1)+1:ind(j),:) = [inner pipes(j+1:n,1)];
    end
end

% Helper function to construct test case array
function [m,ind]= data_dim(n)
    m = 0;
    ind = zeros(n-2,1);
    for i=1:n-1
        m = m+(n-i);
        if i ~= n-1
            ind(i) = m;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Save Results
% Project is being called from the master folder 'PBR Model', so results
% will be saved in 'PBR Model'/Results/'RTE Irradiance'/'Geometry DoE'
function folder = results
    % will return project folder since is called from there
    Project = pwd; 
    folder = sprintf('%s/Results/Sensitivity Test',Project);
end