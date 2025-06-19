function [xhat_dot, Phat_dot] = ExtendedKalmanFilter(xhat, measurements, u, Phat)
    theta = xhat(1);
    psi = xhat(2);
    thetadot = xhat(3);
    psidot = xhat(4);
    
    utilde = u.^2;
    utilde1 = utilde(1);
    utilde2 = utilde(2);
    
    R = diag([2.36e-6; 5.8974e-07]);
    Q = diag([0; 0; 1; 1]);

    % parameters
    g = 9.81;
    dt = 0.158;
    me = 0.2;
    dx = 0.016;
    
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

    Komega = 17.38;

    Kmtheta = 1.26e-6;
    Kttheta = 1.08e-6;
    Kmpsi = Kttheta;
    Ktpsi = Kmtheta; 

    d1 = 0.0031;
    d2 = 0.0075;

    F = [
                                                                                                                                                                                                                                                                                                                                                                                           0, 0,                                                                 1,                                                              0;
                                                                                                                                                                                                                                                                                                                                                                                           0, 0,                                                                 0,                                                              1;
                                                                                                                                                                                                                                                                                                                             -(Ibyy*(2*cos(theta)^2 - 1)*psidot^2 + dx*g*me*cos(theta))/Ibyy, 0,                                                          -d1/Ibyy,                                           -psidot*sin(2*theta);
        (4*Ibyy*psidot*thetadot*(2*cos(theta)^2 - 1) + 2*Kmpsi*Komega^2*dt*utilde1*sin(theta) - 2*Komega^2*Ktpsi*dt*utilde2*sin(theta))/(Ibyy + 2*Ifyzz + Ibyy*(2*cos(theta)^2 - 1)) - (2*Ibyy*cos(theta)*sin(theta)*(d2*psidot + Kmpsi*Komega^2*dt*utilde1*cos(theta) - Komega^2*Ktpsi*dt*utilde2*cos(theta) - 2*Ibyy*psidot*thetadot*cos(theta)*sin(theta)))/(Ibyy*cos(theta)^2 + Ifyzz)^2, 0, (2*Ibyy*psidot*cos(theta)*sin(theta))/(Ibyy*cos(theta)^2 + Ifyzz), -(d2 - Ibyy*thetadot*sin(2*theta))/(Ibyy*cos(theta)^2 + Ifyzz);
    ];
    H = [eye(2), zeros(2)];
    h = H * xhat;

    M = [
        Ibyy, 0;
        0, Ifyzz + Ibyy * cos(theta)^2;
    ];
    C = [
        0, Ibyy * psidot * cos(theta)*sin(theta);
        0, -2*Ibyy * thetadot * cos(theta)*sin(theta);
    ];
    gvec = [
        dx * g * me * sin(theta);
        0;
    ];
    B = Komega^2 * dt * [
        Kmtheta, Kttheta;
        -Kmpsi * cos(theta), Ktpsi * cos(theta);
    ];
    D = [
        d1, 0;
        0, d2;
    ];
    qdot = [
        thetadot;
        psidot;
    ];
    
    f = [
        qdot;
        M \ (B*utilde - C*qdot - gvec - D*qdot);
    ];
    

    K = Phat * H' / R;
    xhat_dot = f + K * (measurements - h);
    Phat_dot = F * Phat + Phat * F' + Q - K * H * Phat;
end