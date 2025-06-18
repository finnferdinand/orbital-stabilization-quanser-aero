% import data
test_input = load('data/test_input.mat').test_input;
reduced_model = load('data/reduced_model.mat').reduced_model;
full_model = load('data/full_model.mat').full_model;
motor_speeds = load('data/motor_speeds.mat').motor_speeds;
measured_pitch = load('data/measured_pitch.mat').measured_pitch;
measured_yaw = load('data/measured_yaw.mat').measured_yaw;

% decode values
t = test_input(1,:);
Vm = test_input(2,:);
Vt = test_input(3,:);

theta_r = reduced_model(2,:);
psi_r = reduced_model(3,:);

theta_f = full_model(2,:);
psi_f = full_model(3,:);

theta_meas = measured_pitch(2,:);
psi_meas = measured_yaw(2,:);

omega_m = motor_speeds(2,:);
omega_t = motor_speeds(3,:);

% calculate motor speed from model
Komega = 17.38;
Vmax = max(Vm);
omega_model = Komega * Vmax;

% plotting
fig = figure(1); clf;
tiledlayout(1,2, 'TileSpacing', 'none', 'Padding', 'compact');
nexttile;
plot(t, Vm, 'LineWidth', 1.5);
hold on; grid on;
plot(t, Vt, 'LineWidth', 1.5);
ylabel("Motor Voltage [V]", "interpreter", "latex");
xlabel("Time [s]", "interpreter", "latex");
legend("\(V_m\)", "\(V_t\)", "interpreter", "latex", "location", "northeast");
xlim([0 t(end)]);
ylim([-0.5 10.5]);
title("Inputs",'interpreter','latex');

cmap = colororder();
nexttile;
plot(t, omega_m);
hold on; grid on;
plot(t, omega_t);
plot([0 5 5 15 15 35], [0,0,omega_model, omega_model,0,0], '-.', 'Color', cmap(1,:), 'LineWidth', 1.5);
plot([0 15 15 25 25 35], [0,0,omega_model, omega_model,0,0], '-.', 'Color', cmap(2,:), 'LineWidth', 1.5);
ylabel("Motor Speed [rad/s]", "interpreter", "latex");
xlabel("Time [s]", "interpreter", "latex");
legend("\(\omega_m\)", "\(\omega_t\)", "\(\hat\omega_m\)", "\(\hat\omega_t\)", "interpreter", "latex", "location", "northeast");
xlim([0 t(end)]);
ylim([-10 235]);
title("Measured and Modeled Motor Speeds",'interpreter','latex');

dims = [200, 200, 800, 300]; % [x_pos, y_pos, x_brd, y_brd]
set(fig, "renderer", "painters", "position", dims, "PaperPositionMode", "auto");
print("-dpng", "-r600", "C:\Users\ffsandva\OneDrive - NTNU\NTNU\2025 10(VÅR)\TTK4900 Masteroppgave\new_experiments\model verification\figures\verification_input_motor_speeds.png");


fig = figure(2); clf;
tiledlayout(1,2, 'TileSpacing', 'none', 'Padding', 'compact');
nexttile;
plot(t, theta_r, 'LineWidth', 1.2);
hold on; grid on;
plot(t, theta_f, ':', 'LineWidth', 1.5);
plot(t, theta_meas, 'k-.', 'LineWidth', 1.2);
ylabel("\(\theta\) [rad]", "interpreter", "latex");
xlabel("Time [s]", "interpreter", "latex");
legend("Reduced Model", "Full Model", "Measurements", "interpreter", "latex", "location", "southwest");
xlim([0 t(end)]);
% ylim([-0.5 10.5]);
title("Pitch Angle",'interpreter','latex');

cmap = colororder();
nexttile;
plot(t, psi_r, 'LineWidth', 1.2);
hold on; grid on;
plot(t, psi_f, ':', 'LineWidth', 1.5);
plot(t, psi_meas, 'k-.', 'LineWidth', 1.2);
ylabel("\(\psi\) [rad]", "interpreter", "latex");
xlabel("Time [s]", "interpreter", "latex");
legend("Reduced Model", "Full Model", "Measurements", "interpreter", "latex", "location", "northwest");
xlim([0 t(end)]);
% ylim([-10 235]);
title("Yaw Angle",'interpreter','latex');

dims = [200, 200, 800, 300]; % [x_pos, y_pos, x_brd, y_brd]
set(fig, "renderer", "painters", "position", dims, "PaperPositionMode", "auto");
print("-dpng", "-r600", "C:\Users\ffsandva\OneDrive - NTNU\NTNU\2025 10(VÅR)\TTK4900 Masteroppgave\new_experiments\model verification\figures\verification_pitch_yaw.png");
