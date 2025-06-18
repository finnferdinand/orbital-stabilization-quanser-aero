kalman_filter_estimates = load('data/kalman_filter_estimates.mat').kalman_filter_estimates;
low_pass_estimates = load('data/low_pass_estimates.mat').low_pass_estimates;

fig = figure(1); clf;
plot(kalman_filter_estimates(1,:), kalman_filter_estimates(4,:),'LineWidth',1);
hold on; grid on;
plot(low_pass_estimates(1,:), low_pass_estimates(4,:),'LineWidth',1);
title('Pitch Velocity','interpreter','latex');
ylim([-0.1,0.6]);
xlabel('\(t\) [s]','interpreter','latex');
ylabel('\(\dot\theta\)','interpreter','latex');

plot([20,20,27,27,20],[-0.025,0.025,0.025,-0.025,-0.025],'k-');
plot([20,22], [0.025,0.32], "k-");
plot([27,29.9], [-0.025,0.15], "k-");
legend('\(\dot\theta\) Kalman','\(\dot\theta\) Low Pass', "", "", "",'interpreter','latex');

axes('position',[0.7 0.4 0.2 0.2]);
box on;
plot(kalman_filter_estimates(1,:), kalman_filter_estimates(4,:),'LineWidth',1);
hold on; grid on;
plot(low_pass_estimates(1,:), low_pass_estimates(4,:),'LineWidth',1);
xlim([20,27]);
ylim([-0.025,0.025]);

dims = [200, 200, 325, 275]; % [x_pos, y_pos, x_brd, y_brd]
set(fig, "renderer", "painters", "position", dims, "PaperPositionMode", "auto");
print("-dpng", "-r600", "/Users/finnferdinandsandvand/Library/CloudStorage/OneDrive-NTNU/NTNU/2025 10(VÅR)/TTK4900 Masteroppgave/new_experiments/Observer Design/figures/pitch_dot_estimates.png");


fig = figure(2); clf;
plot(kalman_filter_estimates(1,:), kalman_filter_estimates(5,:),'LineWidth',1);
hold on; grid on;
plot(low_pass_estimates(1,:), low_pass_estimates(5,:),'LineWidth',1);
title('Yaw Velocity','interpreter','latex');
ylim([-0.1,0.6]);
xlabel('\(t\) [s]','interpreter','latex');
ylabel('\(\dot\psi\)','interpreter','latex');

plot([20,20,27,27,20],[-0.025,0.025,0.025,-0.025,-0.025],'k-');
plot([20,22], [0.025,0.32], "k-");
plot([27,29.9], [-0.025,0.15], "k-");
legend('\(\dot\theta\) Kalman','\(\dot\theta\) Low Pass', "", "", "",'interpreter','latex');

axes('position',[0.7 0.4 0.2 0.2]);
box on;
plot(kalman_filter_estimates(1,:), kalman_filter_estimates(5,:),'LineWidth',1);
hold on; grid on;
plot(low_pass_estimates(1,:), low_pass_estimates(5,:),'LineWidth',1);
xlim([20,27]);
ylim([-0.025,0.025]);

dims = [200, 200, 325, 275]; % [x_pos, y_pos, x_brd, y_brd]
set(fig, "renderer", "painters", "position", dims, "PaperPositionMode", "auto");
print("-dpng", "-r600", "/Users/finnferdinandsandvand/Library/CloudStorage/OneDrive-NTNU/NTNU/2025 10(VÅR)/TTK4900 Masteroppgave/new_experiments/Observer Design/figures/yaw_dot_estimates.png");

