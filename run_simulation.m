open_system('OpenLoopNashFormation');

run('model_init.m')
run('param_init.m')
sim_model = 'OpenLoopNashFormation';
simIn = Simulink.SimulationInput(sim_model);
out = sim(simIn);