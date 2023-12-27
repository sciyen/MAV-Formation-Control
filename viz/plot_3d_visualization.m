function plot_3d_visualization(ts, pos, params, initial, formation, options)
    figure
    colors = options('colors');
    for i = 1:params.N
        if params.m == 2
            plot(pos((i-1)*params.m+1, :),pos((i-1)*params.m+2, :), colors(i),'LineWidth',2); hold on
            scatter(initial.state((i-1)*params.n+1), initial.state((i-1)*params.n+2), 100, colors(i), 'filled'); hold on
            scatter(pos((i-1)*params.m+1, end), pos((i-1)*params.m+2, end), 100, colors(i), 'x'); hold on
        elseif params.m == 3
            plot3(pos((i-1)*params.m+1, :), pos((i-1)*params.m+2, :), pos((i-1)*params.m+3, :), 'color', colors(i, :),'LineWidth',2); hold on
            scatter3(initial.state((i-1)*params.n+1), initial.state((i-1)*params.n+2), initial.state((i-1)*params.n+3), 100, colors(i), 'filled'); hold on
            scatter3(pos((i-1)*params.m+1, end), pos((i-1)*params.m+2, end), pos((i-1)*params.m+3, end), 100, colors(i), 'x'); hold on
            scatter3(formation.desired_pos((i-1)*params.m+1), formation.desired_pos((i-1)*params.m+2), formation.desired_pos((i-1)*params.m+3), 100, colors(i), '^'); hold on
            xlabel('$x$', 'FontSize', 14, 'Interpreter','latex')
            ylabel('$y$', 'FontSize', 14, 'Interpreter','latex')
            zlabel('$z$', 'FontSize', 14, 'Interpreter','latex')
        end
    end
    axis equal
    savefig_helper(options, '_formation')
end
