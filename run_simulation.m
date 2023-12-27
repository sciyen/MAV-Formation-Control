close all;
% open_system('OpenLoopNashFormation');
open_system('DistributedEstimationFormation');

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

figure(1)
% colors = ['b', 'r', 'g', 'k', 'm', 'c', 'b', 'r', 'g', 'k', 'm', 'c'];
colors = colormap(jet(params.N));
for i = 1:params.N
    if params.m == 2
        plot(pos((i-1)*params.m+1, :),pos((i-1)*params.m+2, :), colors(i),'LineWidth',2); hold on
        scatter(initial.state((i-1)*params.n+1), initial.state((i-1)*params.n+2), 100, colors(i), 'filled'); hold on
        scatter(pos((i-1)*params.m+1, end), pos((i-1)*params.m+2, end), 100, colors(i), 'x'); hold on
    elseif params.m == 3
        plot3(pos((i-1)*params.m+1, :), pos((i-1)*params.m+2, :), pos((i-1)*params.m+3, :), 'color', colors(i, :),'LineWidth',2); hold on
        scatter3(initial.state((i-1)*params.n+1), initial.state((i-1)*params.n+2), initial.state((i-1)*params.n+3), 100, colors(i), 'filled'); hold on
        scatter3(pos((i-1)*params.m+1, end), pos((i-1)*params.m+2, end), pos((i-1)*params.m+3, end), 100, colors(i), 'x'); hold on
    end
end

axis equal
return

figure(2)
subplot(2,1,1)
for i = 1:params.N
    plot(ts, u((i-1)*params.p+1, :), colors(i),'LineWidth',2); hold on
end

subplot(2,1,2)
for i = 1:params.N
    plot(ts, u((i-1)*params.p+2, :), colors(i),'LineWidth',2); hold on
end

figure(3)
fll = zeros(length(ts), 1);
for k=1:length(ts)
    % Psi = state_trans(params.T, ts(k), model);
    % fll(k) = Psi(2, 4);
    fll(k) = exp(1 * (params.T - ts(k)));
end

plot(ts, fll, colors(i),'LineWidth',2); hold on
