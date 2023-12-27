function plot_cost_profile(ts, u, pos, params, formation, graph, dfc_opnash, options)
    figure
    colors = options('colors');
    [formation_err, output_regulation, energy_efforts] = calc_total_cost(ts, u, pos, params, formation, graph, dfc_opnash);
    subplot(4,1,1)
    % plot(ts, formation_err, 'LineWidth',2); 
    for i = 1:params.N
        plot(ts, formation_err(:, i), 'LineWidth',2, 'color', colors(i, :)); hold on
    end
    ylabel(["Formation"; "Error"], 'FontSize', 14, 'Interpreter','latex')
    subplot(4,1,2)
    % plot(ts, output_regulation, 'LineWidth',2); 
    for i = 1:params.N
        plot(ts, output_regulation(:, i), 'LineWidth',2, 'color', colors(i, :)); hold on
    end
    ylabel(["Output"; "Regulation"], 'FontSize', 14, 'Interpreter','latex')
    subplot(4,1,3)
    % plot(ts, energy_efforts, 'LineWidth',2); 
    for i = 1:params.N
        plot(ts, energy_efforts(:, i), 'LineWidth',2, 'color', colors(i, :)); hold on
    end
    ylabel(["Energy"; "Efforts"], 'FontSize', 14, 'Interpreter','latex')
    subplot(4,1,4)
    % plot(ts, formation_err + output_regulation + energy_efforts, 'LineWidth',2); 
    for i = 1:params.N
        total = formation_err(:, i) + output_regulation(:, i) + energy_efforts(:, i);
        plot(ts, total, 'LineWidth',2, 'color', colors(i, :)); hold on
    end
    ylabel(["Total"; "Cost"], 'FontSize', 14, 'Interpreter','latex')
    xlabel('$t$ (sec)', 'FontSize', 14, 'Interpreter','latex')
    savefig_helper(options, '_costs')
end 
