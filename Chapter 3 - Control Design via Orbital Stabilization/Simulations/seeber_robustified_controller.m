alpha = 0.75;
x10 = 0;
x20 = 1;
a1 = 1;
a2 = 2;

x0 = [
    x10;
    x20;
    x20 / (a1 * abs(x10)^(2-alpha) + a2 * abs(x20)^((2-alpha)/alpha))^((2*alpha-1)/(2-alpha));
];


T = 50;
%T = 5.4;

kappa = 1;
rho = 1;
eta = 1;
parameters = [alpha, kappa, rho, eta, a1, a2];

options = odeset('MaxStep',1e-3);
[tsim_disturbed, xsim_disturbed] = ode45(@(t,x) f(t,x,1,parameters), [0,T], x0, options);
[tsim_undisturbed, xsim_undisturbed] = ode45(@(t,x) f(t,x,0,parameters), [0,T], x0, options);

% orbit
t = -1:0.01:1;
orbit = -kappa*sign(t).*abs(t).^alpha;

fig = figure(10); clf;
plot(xsim_undisturbed(:,1), xsim_undisturbed(:,2),'linewidth',1);
hold on; grid on;
plot(xsim_disturbed(:,1), xsim_disturbed(:,2),'linewidth',1);
plot(t,orbit,'k-.','linewidth',1);
xlim([-1,1]);
ylim([-1,1]);
pbaspect([1,1,1]);
xlabel('\(x_1\)','Interpreter','latex');
ylabel('\(x_2\)','Interpreter','latex');
%title("Robustified Controller");
legend('Undisturbed', 'Disturbed','location','southwest','interpreter','latex');

% box
plot([-0.01,-0.01,0.01,0.01,-0.01],[-0.1,0.1,0.1,-0.1,-0.1], 'k-');
plot([-0.01,-0.145],[0.1,0.113],'k-');
plot([-0.01,-0.145],[-0.1,-0.39],'k-');
legend('Undisturbed', 'Disturbed','','','','location','southwest','interpreter','latex');

% from https://au.mathworks.com/matlabcentral/answers/33779-zooming-a-portion-of-figure-in-a-figure
axes('position',[.27 .37 .2 .2]);
box on % put box around new pair of axes
%indexOfInterest = (xsim_undisturbed(:,1) < 0.1) & (xsim_undisturbed(:,1) > -0.1); % range of t near perturbation
plot(xsim_undisturbed(:,1),xsim_undisturbed(:,2),'linewidth',1); % plot on new axes
hold on;
plot(xsim_disturbed(:,1),xsim_disturbed(:,2),'linewidth',1);
xlim([-0.01,0.01]);
ylim([-0.1,0.1]); grid on;


dims = [200, 200, 300, 250]; % [x_pos, y_pos, x_brd, y_brd]
set(fig, "renderer", "painters", "position", dims, "PaperPositionMode", "auto");
print("-dpng", "-r600", "/Users/finnferdinandsandvand/git-sandbox/orbital-stabilization-quanser-aero/Controllers/Simulations/figures/seeber_robustified_controller.png");


function xdot = f(t,x,use_disturbance,parameters)
    alpha = parameters(1);
    kappa = parameters(2);
    rho = parameters(3);
    eta = parameters(4);
    a1 = parameters(5);
    a2 = parameters(6);
    
    a = 0.5;
    b = 0.5;
    omega = 1;
    if use_disturbance > 0
        xi = a * sin(omega*t) + b;
    else
        xi = 0;
    end

    x1 = x(1);
    x2 = x(2);
    z = x(3);

    sigma = x2 + kappa * sign(x1) * abs(x1)^alpha;
    mu = alpha * kappa^(1/alpha) + rho;
    k = alpha * kappa^2 * sign(x1) * abs(x1)^(2*alpha-1) ...
        - mu * sign(sigma) * abs(sigma)^((2*alpha-1)/alpha);

    h = x2 / (a1 * abs(x1)^(2-alpha) + a2 * abs(x2)^((2-alpha)/alpha))^((2*alpha-1)/(2-alpha));
    dhdx1 = a1 * (1-2*alpha) * abs(x1)^(1-alpha) * x2 / (a1 * abs(x1)^(2-alpha) + a2 * abs(x2)^((2-alpha)/alpha))^((alpha+1)/(2-alpha));
    dhdx2 = 1 / (a1 * abs(x1)^(2-alpha) + a2 * abs(x2)^((2-alpha)/alpha))^((2*alpha-1)/(2-alpha)) + a2 * (1-2*alpha)/alpha * sign(x2) * abs(x2)^(1/alpha) / (a1 * abs(x1)^(2-alpha) + a2 * abs(x2)^((2-alpha)/alpha))^((alpha+1)/(2-alpha));

    % handle singular cases
    if isnan(dhdx1)
        dhdx1 = 0;
    end
    if isnan(dhdx2)
        dhdx2 = 0;
    end
    if isnan(h)
        h = 0;
    end

    u = k - eta * h + eta * z;
    zdot = dhdx1 * x2 + dhdx2 * k;

    xdot = [
        x2;
        u + xi;
        zdot;
    ];
end