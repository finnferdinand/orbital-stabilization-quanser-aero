% import data
input = load('data/input.mat').input;
yaw = load('data/yaw.mat').yaw;

% constants
g = 9.81;
dt = 0.158;
me = 0.2;

ry = 0.02;
my = 0.526;

mpa = 0.146;
lt = 0.165;
mmt = 0.089;
mtt = 0.089;
mtc = 0.280;
mrod = mmt + mtt + mtc;

Ibyy = 2*mpa*dt^2 + 2*me*dt^2 + me*dx^2 + 1/12*mrod*lt^2;
Ifyzz = 1/2*my*ry^2;

dt = 0.002;
omega_n = 50;
zeta = 0.8;
numerator = [omega_n^2, 0];
denominator = [1, 2*zeta*omega_n, omega_n^2];
sys = tf(numerator,denominator);
yaw_speed = [
    yaw(1,:); % keep time information
    lsim(sys,yaw(2,:),yaw(1,:))';
];


% find points
[pks,locs] = findpeaks(yaw_speed(2,:),"MinPeakProminence",0.1);
crop = yaw_speed(2,locs(1):end);
filter = crop < 0.37 * pks(1);
tconst_loc = find(filter);
tconst_loc = locs(1) + tconst_loc(1);
point = yaw_speed(2, tconst_loc);
tconst = yaw_speed(1,tconst_loc) - yaw_speed(1,locs(1));

d_psi = (Ifyzz + Ibyy) / tconst;

% make figure
fig = figure(1); clf;
tiledlayout(2,1, 'TileSpacing', 'none', 'Padding', 'compact');
nexttile;
plot(yaw_speed(1,:), yaw_speed(2,:), 'LineWidth', 1.5); 
grid on;
ylim([min(yaw_speed(2,:)) - 0.1, max(yaw_speed(2,:)) + 0.1]);
title("Yaw Velocity Response", 'interpreter','latex');
hold on;

scatter([yaw_speed(1,locs), yaw_speed(1,tconst_loc)] , [yaw_speed(2,locs), point], 'LineWidth', 1.5);
xline(yaw_speed(1,locs(1)), 'LineWidth', 1.5);
xline(yaw_speed(1,tconst_loc), 'LineWidth', 1.5);
ylabel("\(\dot\psi\) [rad]", "interpreter","latex");
xticklabels([]); % same x ticks as plot below

fprintf("Point 1: %.4f, Time 1: %.2fs\n", yaw_speed(2,locs(1)), yaw_speed(1,locs(1)));
fprintf("Point 2: %.4f, Time 2: %.2fs\n", point, yaw_speed(1,tconst_loc));
fprintf("Time Constant: %.2fs\n", tconst);
fprintf("d_psi: %.4f\n", d_psi);

nexttile;
plot(input(1,:), input(2,:), 'LineWidth', 1.5);
grid on;
ylim([min(input(2,:)) - 2, max(input(2,:)) + 2]);
title("Input", 'interpreter','latex');
ylabel("\(V_t\) [V]", "interpreter","latex");
xlabel("\(t\) [s]", "interpreter","latex");

dims = [200, 200, 400, 400]; % [x_pos, y_pos, x_brd, y_brd]
set(fig, "renderer", "painters", "position", dims, "PaperPositionMode", "auto");
print("-dpng", "-r600", "C:\Users\ffsandva\OneDrive - NTNU\NTNU\2025 10(VÅR)\TTK4900 Masteroppgave\new_experiments\yaw_coefficients\figures\impulse_yaw.png");
