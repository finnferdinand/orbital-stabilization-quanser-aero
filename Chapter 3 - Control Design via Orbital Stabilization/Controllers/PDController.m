function u = PDController(e, edot, kappa, mu)
    % u = PDController(e, edot, kappa, mu) computes the feedback control 
    % for a Proportional-Derivative controller given the positive 
    % parameters kappa and mu.
    %
    % Author:   Finn F. Sandvand
    % Date:     15th Jun 2025
    % Revisions: 

    if kappa <= 0 || mu <= 0
        error('Error. kappa and mu must be positive');
    elseif kappa >= mu
        error('Error. kappa must be greater than mu');
    end

    sigma = edot + kappa * e;
    u = kappa^2 * e - mu * sigma;
end
