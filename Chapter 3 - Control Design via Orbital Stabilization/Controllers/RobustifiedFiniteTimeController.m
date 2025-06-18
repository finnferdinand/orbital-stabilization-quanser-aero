function [u, zdot] = RobustifiedFiniteTimeController(e, edot, z, kappa, alpha, rho, eta)
    % [u, zdot] = RobustifiedFiniteTimeController(e, edot, z, kappa, alpha, rho, eta) 
    % computes the feedback control for a robustified finite-time
    % controller given the positive parameters kappa, alpha, rho and eta.
    %
    % Author:   Finn F. Sandvand
    % Date:     15th Jun 2025
    % Revisions: 

    sigma = edot + kappa * sign(e) * abs(e)^alpha;
    mu = alpha * kappa^(1/alpha) + rho;
    u = alpha * kappa^2 * sign(e) * abs(e)^(2*alpha-1) ...
        - mu * sign(sigma) * abs(sigma)^((2*alpha-1)/alpha) - eta * z;
    zdot = sign(sigma);
end

