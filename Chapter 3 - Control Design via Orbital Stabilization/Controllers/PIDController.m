function [u, zdot] = PIDController(e, edot, z, kappa, mu, eta)
    % [u, zdot] = RobustifiedFiniteTimeController(e, edot, z, kappa, mu, eta) 
    % computes the feedback control for a Proportional-Integral-Derviative
    % controller given the positive parameters kappa, mu and eta.
    %
    % Author:   Finn F. Sandvand
    % Date:     15th Jun 2025
    % Revisions: 

    if kappa <= 0 || mu <= 0 || eta <= 0
        error('Error. kappa, mu and eta must be positive');
    elseif kappa >= mu
        error('Error. kappa must be greater than mu');
    end

    sigma = edot + kappa * e;
    u = -kappa*(mu - kappa) * e - mu * edot - eta * z;
    zdot = sigma;
end
