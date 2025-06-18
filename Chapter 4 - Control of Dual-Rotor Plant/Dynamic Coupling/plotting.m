% load data
free_pitch = load('data/free_pitch/pitch.mat').pitch;
free_yaw_speed = load('data/free_pitch/yaw_speed.mat').yaw_speed;

locked_pitch = load('data/locked_pitch/pitch.mat').pitch;
locked_yaw_speed = load('data/locked_pitch/yaw_speed.mat').yaw_speed;

initial_t = 5;
t_index = find(free_pitch(1,:) == initial_t);

% figures
fig = figure(1); clf;
tiledlayout(1,2, 'TileSpacing', 'none', 'Padding', 'compact');
nexttile;
plot(free_pitch(1,t_index:end) - initial_t, free_pitch(2,t_index:end), 'LineWidth', 1.5);
xlabel('\(t\) [s]', "interpreter", "latex");
ylabel('\(\theta\) [rad]', "interpreter", "latex");
grid on;
title("Pitch Angle",'interpreter','latex');
ylim([-1,1]);

nexttile;
plot(free_yaw_speed(1,t_index:end) - initial_t, free_yaw_speed(2,t_index:end), 'LineWidth', 1.5);
xlabel('\(t\) [s]', "interpreter", "latex");
ylabel('\(\dot\psi\) [rad/s]', "interpreter", "latex");
grid on;
title("Yaw Angular Velocity",'interpreter','latex');
ylim([-0.5, 5]);

dims = [200, 200, 700, 300]; % [x_pos, y_pos, x_brd, y_brd]
set(fig, "renderer", "painters", "position", dims, "PaperPositionMode", "auto");
print("-dpng", "-r600", "C:\Users\ffsandva\OneDrive - NTNU\NTNU\2025 10(VÅR)\TTK4900 Masteroppgave\new_experiments\dynamic_coupling\figures\free.png");


fig = figure(2); clf;
tiledlayout(1,2, 'TileSpacing', 'none', 'Padding', 'compact');
nexttile;
plot(locked_pitch(1,t_index:end) - initial_t, locked_pitch(2,t_index:end), 'LineWidth', 1.5);
xlabel('\(t\) [s]', "interpreter", "latex");
ylabel('\(\theta\) [rad]', "interpreter", "latex");
grid on;
title("Pitch Angle",'interpreter','latex');
ylim([-1,1]);

nexttile;
plot(locked_yaw_speed(1,t_index:end) - initial_t, locked_yaw_speed(2,t_index:end), 'LineWidth', 1.5);
xlabel('\(t\) [s]', "interpreter", "latex");
ylabel('\(\dot\psi\) [rad/s]', "interpreter", "latex");
grid on;
title("Yaw Angular Velocity",'interpreter','latex');
ylim([-0.5, 5]);

dims = [200, 200, 700, 300]; % [x_pos, y_pos, x_brd, y_brd]
set(fig, "renderer", "painters", "position", dims, "PaperPositionMode", "auto");
print("-dpng", "-r600", "C:\Users\ffsandva\OneDrive - NTNU\NTNU\2025 10(VÅR)\TTK4900 Masteroppgave\new_experiments\dynamic_coupling\figures\locked.png");

