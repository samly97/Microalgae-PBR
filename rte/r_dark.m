% Returns the point (radius) at which the area is not illuminated, or in
% other words, G(r) < 15 umol/m^2/s. If the whole cross-section is
% illuminated, it returns the outer diameter.
%
% Inputs:
%   qo: Light intensity at the inner diameter
%   G: Normalized irradiance function (G/q)
%   r_o: Radius of inner tube (m)
%   R: Radius of outer tube (m)
%
% Outputs:
%   R_c:
function R_c = r_dark(qo,G,r_o,R)
    G_o = G(r_o);
    f = @(r) qo*(G(r)/G_o) - 15;
    
    if f(R) > 0
        R_c = R;
    else
        R_c = bisection(f,r_o,R);
%         try
%             R_c = fzero(f,(R+r_o)/2);
%         catch ME
%             msg = sprintf('d:%f D:%f\n',r_o*100*2,R*100*2);
%             warning(msg);
%             R_c = bisection(f,r_o,R);
%         end
    end
end

function c = bisection(f,r_l,r_u)
    n = ceil(log2((r_u-r_l)/10^-7));
    % initialize lower and upper bounds
    a = r_l;
    b = r_u;
    
    for i = 1:n
        c = (a+b)/2;
        if f(c) > 0
            a=c;
        else
            b=c;
        end
    end
end