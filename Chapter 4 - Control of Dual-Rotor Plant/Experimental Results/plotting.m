folders.nominal = "data/Experiment 1 - Nominal/" + {
    'PD Controller', ...
    'PID Controller', ...
    'Continuous Finite-Time Controller', ...
    'Robustified Finite-Time Controller', ...
    'Seeber Robustified Finite-Time Controller'
};
folders.added_mass = "data/Experiment 2 - Added Mass/" + {
    'PD Controller', ...
    'PID Controller', ...
    'Continuous Finite-Time Controller', ...
    'Robustified Finite-Time Controller', ...
    'Seeber Robustified Finite-Time Controller'
};
folders.friction = "data/Experiment 3 - Friction/" + {
    'PD Controller', ...
    'PID Controller', ...
    'Continuous Finite-Time Controller', ...
    'Robustified Finite-Time Controller', ...
    'Seeber Robustified Finite-Time Controller'
};

% titles.nominal = {
%     'PD Controller', ...
%     'PID Controller', ... 
%     'Continuous Homogeneous Controller', ...
%     'Continuous Homogeneous Robust Controller', ... 
%     'Seeber'
% };
% titles.added_mass = {
%     'PD Controller (added mass)', ...
%     'PID Controller (added mass)', ...
%     'Continuous Homogeneous Controller (added mass)', ...
%     'Continuous Homogeneous Robust Controller (added mass)', ... 
%     'Seeber (added mass)'
% };
% titles.friction = {
%     'PD Controller (friction)', ...
%     'PID Controller (friction)', ...
%     'Continuous Homogeneous Controller (friction)', ...
%     'Continuous Homogeneous Robust Controller (friction)', ...
%     'Seeber (friction)'
% };
titles = {
    'PD Controller', ...
    'PID Controller', ... 
    'CFT Controller', ...
    'RFT Controller', ... 
    'SRFT Controller'
}

n_controllers = length(folders.nominal);
experiments = {'Nominal', 'Added Mass', 'Friction'};
n_experiments = length(experiments);

all_folders = {folders.nominal, folders.added_mass, folders.friction};
% all_titles = {titles.nominal, titles.added_mass, titles.friction};

for experiment_number=1:n_experiments
    fig = figure(experiment_number); clf;
    tiledlayout(n_controllers, 3, 'TileSpacing', 'compact', 'Padding', 'compact');
    x_end = load(strcat(all_folders{experiment_number}{1}, '/reference')).ans(1,end);
    
    for controller_number=1:n_controllers
        folder = all_folders{experiment_number}{controller_number};
        reference = load(strcat(folder, '/reference')).ans;
        real_control = load(strcat(folder, '/real_control')).ans;
        measurements = load(strcat(folder, '/measurements')).ans;
        ttle = titles{controller_number};

        Vmax = 24;
        real_control(2:3,:) = min(Vmax, max(-Vmax, real_control(2:3,:)));

        cmap = colororder();
        %subplot(n_controllers, 2, 2 * controller_number - 1);
        nexttile;
        plot(reference(1,:), reference(2:3,:), ':', "LineWidth", 1.5); hold on; grid on;
        colororder(cmap);
        plot(measurements(1,:), measurements(2:3,:), '-', "LineWidth", 1.5);
        line_color = ["#0072BD" "#D95319" "#0072BD" "#D95319"];
        colororder(line_color);
        title('Angles',"interpreter","latex");
        lgd = legend("\(\theta_r\)", "\(\psi_r\)", "\(\theta\)", "\(\psi\)", "interpreter", "latex", "Location", "southeast");
        xlim([0, x_end]);
        ylabel("\(\theta,\psi\) [rad]","interpreter","latex");
        xlabel("\(t\) [s]", "interpreter","latex");
        if experiment_number == 2
            xlim([30, x_end]);
            if controller_number == 1 || controller_number == 3
                lgd.FontSize = 6;
            end
        end
        ylim([0, 1]);
%         a = annotation( 'textbox', 'String', 'my annotation', ...
%             'FontSize', 14, 'Units', 'normalized', 'EdgeColor', 'none', ...
%             'Position', [0.95,0.5,0.2,0]);
%         a.TextRotation = 90;
        

        %subplot(n_controllers, 2, 2 * controller_number);
        nexttile;
        plot(real_control(1,:), real_control(2:3,:), '-', "LineWidth", 1);
        grid on;
        title('Control',"interpreter","latex");
        %line_color = ["b" "r"];
        %colororder(line_color);
        legend("\(V_m\)", "\(V_t\)","interpreter","latex","location","southeast");
        if experiment_number == 2
            xlim([30, x_end]);
        else
            xlim([0, x_end]);
        end
        ylabel("\(V_m, V_t\) [V]","interpreter","latex");
        xlabel("\(t\) [s]", "interpreter","latex");

        nexttile;
        plot(measurements(2,:)-pi/6, measurements(4,:)); hold on; grid on;
        plot(measurements(3,:)-pi/4, measurements(5,:));
        title('Phase Portrait',"interpreter","latex");
        legend("\(\theta,\dot\theta\)", "\(\psi,\dot\psi\)", "interpreter", "latex", "Location", "northeast");
        xlim([-1,0.3]);
        ylim([-0.3,1]);

        ylabel("\(\dot\theta,\dot\psi\) [rad/s]","interpreter","latex");
        xlabel("\(\theta,\psi\) [rad]", "interpreter","latex");

        h_text = text(0.4, 0.4, ttle, ...
              'FontSize', 14, ...
              'Rotation', -90, ...
              'HorizontalAlignment', 'center', ...
              'VerticalAlignment', 'middle', ...
              'Interpreter', 'latex');
    end
    % sgtitle(experiments{experiment_number});

    dims = [200, 200, 600, 900]; % [x_pos, y_pos, x_brd, y_brd]
    set(fig, "renderer", "painters", "position", dims, "PaperPositionMode", "auto");
    path = sprintf("/Users/finnferdinandsandvand/Library/CloudStorage/OneDrive-NTNU/NTNU/2025 10(VÅR)/TTK4900 Masteroppgave/new_experiments/Experimental Results/figures/%s", experiments{experiment_number});
    print("-dpng", "-r600", path);
    fprintf("Saved Figure: %s\n", experiments{experiment_number});
end
