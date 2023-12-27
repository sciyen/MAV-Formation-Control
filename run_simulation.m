close all;
% open_system('OpenLoopNashFormation');
open_system('DistributedEstimationFormation');
options = gen_save_options();
options('foldername') = "./outputs/distributed/";
% options('filename') = "v_11_laplace_1";
options('filename') = "v_11";

run('param_init.m')
run('strategy_dfc_opnash.m')
% sim_model = 'OpenLoopNashFormation';
sim_model = 'DistributedEstimationFormation';
simIn = Simulink.SimulationInput(sim_model);
% out = sim(simIn);

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
