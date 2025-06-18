% measurements: main motor -> pitch angle
measurements_main_pitch = [
    % end pitch angle (rad), main motor speed (rad/s), main motor voltage (V)
    0, 0, 0;
    0, 12.2, 1;
    0, 40.5, 2;
    6e-3, 63, 3;
    0.03, 83, 4;
    0.05, 102, 5;
    0.08, 118, 6;
    0.104, 134, 7;
    0.141, 150, 8;
    0.166, 166, 9;
    0.205, 182, 10;
    0.248, 198, 11;
    0.26, 213, 12;
    0.337, 228, 13;
    0.385, 242, 14;
    0.42, 256, 15;
    0.494, 269, 16;
    0.528, 283, 17;
    0.63, 296, 18;
];

% measurements: tail motor -> pitch angle
measurements_tail_pitch = [
    % end pitch angle (rad), tail motor speed (rad/s), tail motor voltage (V)
    0, 0, 0;
    0, 12.4, 1;
    0.012, 41, 2;
    0.024, 63.2, 3;
    0.03, 83.5, 4;
    0.046, 102.5, 5;
    0.065, 120, 6;
    0.095, 135, 7;
    0.129, 150, 8;
    0.162, 166, 9;
    0.19, 183, 10;
    0.218, 198, 11;
    0.236, 213, 12;
    0.276, 228, 13;
    0.316, 243, 14;
    0.386, 257, 15;
    0.399, 271, 16;
    0.453, 284, 17;
    0.509, 296, 18;
];

% data for curve fitter
main_motor_voltage_pitch = measurements_main_pitch(:,3);
main_motor_speed_pitch = measurements_main_pitch(:,2);
sin_pitch_angle_main = sin(measurements_main_pitch(:,1));

tail_motor_speed_pitch = measurements_tail_pitch(:,2);
sin_pitch_angle_tail = sin(measurements_tail_pitch(:,1));

% result from curve fitter
k_main_pitch = 6.364e-06;
Rsquare_main_pitch = 0.9945;

k_tail_pitch = 5.434e-06;
Rsquare_tail_pitch = 0.9966;

k_omega = 17.38;
Rsquare_omega = 0.9881;


% known constants
g = 9.81;
dt = 0.158;
me = 0.200;
dx = 0.016;

ry = 0.02;
my = 0.526;

mpa = 0.146;
lt = 0.165;
mmt = 0.089;
mtt = 0.089;
mtc = 0.280;
mrod = mmt + mtt + mtc;

Ifyzz = 1/2 * my * ry^2;
Ibyy = 2 * mpa * dt^2 + 2 * me * dt^2 + me * dx^2 + 1/12 * mrod * lt^2;

% coefficients
K_mtheta = k_main_pitch * dx * g * me / dt;
K_ttheta = k_tail_pitch * dx * g * me / dt;
K_omega = k_omega;

fprintf("K_mtheta = %d, R^2 = %.4f\n", K_mtheta, Rsquare_main_pitch);
fprintf("K_ttheta = %d, R^2 = %.4f\n", K_ttheta, Rsquare_tail_pitch);
fprintf("K_omega = %.2f, R^2 = %.4f\n", K_omega, Rsquare_omega);

t = 0:0.1:measurements_main_pitch(end,2);

% PLOT COEFFICIENTS FOR PITCH THRUSTS
fig = figure(10); clf;
tiledlayout(1,2, 'TileSpacing', 'none', 'Padding', 'compact');
nexttile;
scatter(measurements_main_pitch(:,2), measurements_main_pitch(:,1), 'LineWidth', 1.5);
hold on;
plot(t, k_main_pitch*t.^2, 'k-', 'LineWidth', 1.5);
xlabel("\(\omega_m\) [rad/s]","interpreter","latex");
ylabel("\(\sin(\theta_e)\)","interpreter","latex");
grid on;
title("Pitch equilibrium against main motor speed", "interpreter", "latex");
legend("Measurements", "Fit", "location", "northwest", "interpreter", "latex");

nexttile;
scatter(measurements_tail_pitch(:,2), measurements_tail_pitch(:,1), 'LineWidth', 1.5);
hold on;
plot(t, k_tail_pitch*t.^2, 'k-', 'LineWidth', 1.5);
xlabel("\(\omega_t\) [rad/s]","interpreter","latex");
ylabel("\(\sin(\theta_e)\)","interpreter","latex");
grid on;
title("Pitch equilibrium against tail motor speed", "interpreter", "latex");
legend("Measurements", "Fit", "location", "northwest", "interpreter", "latex");

dims = [200, 200, 700, 300]; % [x_pos, y_pos, x_brd, y_brd]
set(fig, "renderer", "painters", "position", dims, "PaperPositionMode", "auto");
print("-dpng", "-r600", "C:\Users\ffsandva\OneDrive - NTNU\NTNU\2025 10(VÅR)\TTK4900 Masteroppgave\new_experiments\Coefficient Estimation\figures\curve_fit_theta.png");


% PLOT COEFFICIENT FOR MOTOR SPEED
fig = figure(13); clf;
scatter(main_motor_voltage_pitch, main_motor_speed_pitch,'LineWidth',1.5);
xlabel("\(V_m\) [V]","Interpreter","latex");
ylabel("\(\omega_m\) [rad]","Interpreter","latex");
grid on; hold on;
t = 0:0.01:main_motor_voltage_pitch(end);
plot(t,k_omega * t, "k-",'LineWidth',1.5);
title("Main motor speed against motor voltage", "interpreter", "latex");
legend("Measurements", "Fit","Location","northwest", "interpreter", "latex");

dims = [200, 200, 350, 300]; % [x_pos, y_pos, x_brd, y_brd]
set(fig, "renderer", "painters", "position", dims, "PaperPositionMode", "auto");
print("-dpng", "-r600", "C:\Users\ffsandva\OneDrive - NTNU\NTNU\2025 10(VÅR)\TTK4900 Masteroppgave\new_experiments\Coefficient Estimation\figures\curve_fit_omega.png");
