close all;
% open_system('OpenLoopNashFormation');
open_system('DistributedEstimationFormation');
options = gen_save_options();
% options('foldername') = "./outputs/global_info/";
options('foldername') = "./outputs/distributed/";
% options('filename') = "v_11_laplace_1";
options('filename') = "v_11";
% options('filename') = "v_11_Ff1_1";

run('param_init.m')
run('strategy_dfc_opnash.m')
% sim_model = 'OpenLoopNashFormation';
sim_model = 'DistributedEstimationFormation';
simIn = Simulink.SimulationInput(sim_model);
out = sim(simIn);

ts = out.tout;
x = get(out.xout, 'x').Values.Data;
pos = get(out.logsout, 'output_positions').Values.Data;
u = get(out.logsout, 'u').Values.Data;


pos = squeeze(pos);
u = squeeze(u);

options('colors') = colormap(jet(params.N));

plot_3d_visualization(ts, pos, params, initial, formation, options)
plot_inputs_profile(ts, u, params, options)
plot_cost_profile(ts, u, pos, params, formation, graph, dfc_opnash, options)

if strcmp(sim_model, 'DistributedEstimationFormation') == 1
    y_hat = get(out.xout, 'y_hat').Values.Data;
    plot_y_hat_profile(ts, y_hat, params, options)
end

function plot_y_hat_profile(ts, y_hat, params, options)
    y_hat = y_hat';
    figure
    colors = options('colors');
    subplot(params.m,1,1)
    for i = 1:params.N
        plot(ts, y_hat((i-1)*params.p+1, :)', 'color', colors(i, :),'LineWidth',2); hold on
    end
    ylabel('$\mathbf{p}_x$', 'FontSize', 14, 'Interpreter','latex')
    % ylim([-0.1, 0.1])

    subplot(params.m,1,2)
    for i = 1:params.N
        plot(ts, y_hat((i-1)*params.p+2, :)', 'color', colors(i, :),'LineWidth',2); hold on
    end
    ylabel('$\mathbf{p}_y$', 'FontSize', 14, 'Interpreter','latex')
    % ylim([-0.2, 0.2])

    if params.m == 3
        subplot(params.m,1,3)
        for i = 1:params.N
            plot(ts, y_hat((i-1)*params.p+3, :)', 'color', colors(i, :),'LineWidth',2); hold on
        end
    end
    ylabel('$\mathbf{p}_z$', 'FontSize', 14, 'Interpreter','latex')
    xlabel('$t$ (sec)', 'FontSize', 14, 'Interpreter','latex')
    % ylim([-0.05, 0.05])
    savefig_helper(options, '_y_hat')
end