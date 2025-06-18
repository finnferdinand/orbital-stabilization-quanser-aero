% import data
input = load('data/input.mat').input;
pitch_speed = load('data/pitch_speed.mat').pitch_speed;
pitch = load('data/pitch.mat').pitch;

% find peaks
[pks,locs] = findpeaks(pitch(2,:));

% constants
g = 9.81;
dt = 0.158;
me = 0.2;

mpa = 0.146;
lt = 0.165;
mmt = 0.089;
mtt = 0.089;
mtc = 0.280;
mrod = mmt + mtt + mtc;

% make figure
fig = figure(1); clf;
tiledlayout(2,1, 'TileSpacing', 'none', 'Padding', 'compact');
nexttile;
plot(pitch(1,:), pitch(2,:), 'LineWidth', 1.5); 
grid on;
ylim([min(pitch(2,:)) - 0.1, max(pitch(2,:)) + 0.1]);
title("Pitch response",'interpreter','latex');
hold on;
scatter(pitch(1,locs), pitch(2,locs), 'LineWidth', 1.5);
xline(pitch(1,locs(1)), 'LineWidth', 1.5);
xline(pitch(1,locs(4)), 'LineWidth', 1.5);
ylabel("\(\theta\) [rad]", "interpreter","latex");
xticklabels([]); % same x ticks as plot below

O1 = pitch(2,locs(1));
t1 = pitch(1,locs(1));
O4 = pitch(2,locs(4));
t4 = pitch(1,locs(4));
Tosc = (t4 - t1) / 3;
delta = 1/4 * log(O1 / O4);
zeta = 1/sqrt(1 + (2*pi / delta)^2);
omega_d = 2 * pi / Tosc;
omega_n = omega_d / sqrt(1 - zeta^2);

fprintf("Peak 1: %.4f, Time: %.2fs\n", O1, t1);
fprintf("Peak 4: %.4f, Time: %.2fs\n", O4, t4);
fprintf("Period: %.2fs\n", Tosc);
fprintf("Subsidence ratio: %.4f\n", delta);
fprintf("zeta: %.4f\n", zeta);
fprintf("omega_n: %.2f\n", omega_n);

a = omega_n^2 * me;
b = -g * me;
c = omega_n^2 * (2*mpa*dt^2+2*me*dt^2+1/12*mrod*lt^2);
dx = (-b - sqrt(b^2 - 4*a*c))/(2*a);
fprintf("d_x: %.4f\n", dx);

Ibyy = 2*mpa*dt^2 + 2*me*dt^2 + me*dx^2 + 1/12*mrod*lt^2;
fprintf("d_theta: %.4f\n", 2*Ibyy*zeta*omega_n);

nexttile;
plot(input(1,:), input(2,:), 'LineWidth', 1.5);
grid on;
ylim([min(input(2,:)) - 2, max(input(2,:)) + 2]);
title("Input",'interpreter','latex');
ylabel("\(V_m\) [V]", "interpreter","latex");
xlabel("\(t\) [s]", "interpreter","latex");

dims = [200, 200, 400, 400]; % [x_pos, y_pos, x_brd, y_brd]
set(fig, "renderer", "painters", "position", dims, "PaperPositionMode", "auto");
print("-dpng", "-r600", "C:\Users\ffsandva\OneDrive - NTNU\NTNU\2025 10(VÅR)\TTK4900 Masteroppgave\new_experiments\pitch_coefficients\figures\impulse_pitch.png");
