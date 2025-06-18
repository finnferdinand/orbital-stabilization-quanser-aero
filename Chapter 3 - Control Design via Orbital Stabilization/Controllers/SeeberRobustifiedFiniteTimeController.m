function [u, zdot] = SeeberRobustifiedFiniteTimeController(e, edot, z, kappa, alpha, rho, a1, a2, eta)
    % [u, zdot] = SeeberRobustifiedFiniteTimeController(e, edot, z, kappa, alpha, rho, a1, a2, eta) 
    % computes the feedback control for a robustified finite-time
    % controller given the positive parameters kappa, alpha, rho, a1, a2
    % and eta.
    %
    % Author:   Finn F. Sandvand
    % Date:     15th Jun 2025
    % Revisions: 

    sigma = edot + kappa * sign(e) * abs(e)^alpha;
    mu = alpha * kappa^(1/alpha) + rho;
    k = alpha * kappa^2 * sign(e) * abs(e)^(2*alpha-1) ...
        - mu * sign(sigma) * abs(sigma)^((2*alpha-1)/alpha);

    h = edot / (a1 * abs(e)^(2-alpha) + a2 * abs(edot)^((2-alpha)/alpha))^((2*alpha-1)/(2-alpha));
    dhdx1 = a1 * (1-2*alpha) * abs(e)^(1-alpha) * edot / (a1 * abs(e)^(2-alpha) + a2 * abs(edot)^((2-alpha)/alpha))^((alpha+1)/(2-alpha));
    dhdx2 = 1 / (a1 * abs(e)^(2-alpha) + a2 * abs(edot)^((2-alpha)/alpha))^((2*alpha-1)/(2-alpha)) + a2 * (1-2*alpha)/alpha * sign(edot) * abs(edot)^(1/alpha) / (a1 * abs(e)^(2-alpha) + a2 * abs(edot)^((2-alpha)/alpha))^((alpha+1)/(2-alpha));

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
    zdot = dhdx1 * edot + dhdx2 * k;
end
