function u = TerminalSlidingModeController(e, edot, kappa, rho, epsilon)
    % u = TerminalSlidingModeController(e, edot, kappa, rho, epsilon) 
    % computes the feedback control for a terminal sliding mode controller 
    % given the positive parameters kappa, rho and epsilon.
    %
    % Author:   Finn F. Sandvand
    % Date:     15th Jun 2025
    % Revisions: 

    sign_e = e / (abs(e) + epsilon);
    sigma = edot + kappa * sign_e * sqrt(abs(e));
    sign_sigma = sigma / (abs(sigma) + epsilon);
    
    mu = 0.5 * kappa^2 + rho;
    u = 0.5 * kappa^2 * sign_e - mu * sign_sigma;
end
