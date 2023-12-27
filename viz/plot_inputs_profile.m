function plot_inputs_profile(ts, u, params, options)
    figure
    colors = options('colors');
    subplot(params.m,1,1)
    for i = 1:params.N
        plot(ts, u((i-1)*params.p+1, :)', 'color', colors(i, :),'LineWidth',2); hold on
    end
    ylabel('$u_x$', 'FontSize', 14, 'Interpreter','latex')
    ylim([-0.1, 0.1])

    subplot(params.m,1,2)
    for i = 1:params.N
        plot(ts, u((i-1)*params.p+2, :)', 'color', colors(i, :),'LineWidth',2); hold on
    end
    ylabel('$u_y$', 'FontSize', 14, 'Interpreter','latex')
    ylim([-0.2, 0.2])

    if params.m == 3
        subplot(params.m,1,3)
        for i = 1:params.N
            plot(ts, u((i-1)*params.p+3, :)', 'color', colors(i, :),'LineWidth',2); hold on
        end
    end
    ylabel('$u_z$', 'FontSize', 14, 'Interpreter','latex')
    xlabel('$t$ (sec)', 'FontSize', 14, 'Interpreter','latex')
    ylim([-0.05, 0.05])
    savefig_helper(options, '_inputs')
end 
