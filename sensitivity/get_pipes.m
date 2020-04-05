function pipes = get_pipes(thickness)
    od = pipe_od();
    id = pipe_id(od,thickness);
    % cost = pipe_cost(); worry about this later
    pipes = [id od];
end

function cost = pipe_cost()
    cost = [33.08;33.51;33.94;34.87;35.16;35.47;36.05;36.67; ...
        37.42;37.48;37.85;37.85;38.13;38.59;39.02;39.52;40.06; ...
        40.44;40.75;40.93;41.09;41.52;41.9;42.13;42.37;42.81; ...
        43.12;43.37;43.72;44.01;44.4;44.68;45.03;46.02;47.01; ...
        47.99;48.51;49.64;50.03;50.88;54.89;56.87;58.58; ...
        60.72;63.88;65.51;66.96;81.3;82.31;83.22;83.59;89.29; ...
        103.04;117.13;137.03;245.61;269.13;296.19;321.03;332.5;589.07;824.59];
end

function pipes = pipe_od()
    % https://www.eplastics.com/cast-acrylic-tubing-size-list
    % specs:
    % Clear, polished, Random 71" - 73" Lengths
    % Thickness (in):
    % .125, .187, .250, .375, and .500 inches
    
    % in inches
    pipe_od=[1.25;1.5;1.625;1.75;1.875;2;2.25;2.375;2.5;2.625; ...
        2.75;2.875;3;3.125;3.25;3.375;3.5;3.625;3.75;3.875;4; ...
        4.125;4.25;4.375;4.5;4.625;4.75;4.875;5;5.25;5.5;5.625; ...
        5.75;6;6.093;6.25;6.5;6.75;7;7.25;7.5;7.625;8;8.25;8.5;8.75;9; ...
        10;10.5;10.625;11;11.5;11.75;12;12.5;13.625;14;15;16;18;24;27.625];
    % in centimeters
    pipes= pipe_od*2.54;
end

% lets use the smallest size as a default
% no reason not to at the moment
function pipes = pipe_id(pipes,thickness)
    % in centimeters
    thickness = thickness*2.54;
    pipes = pipes - thickness;
end