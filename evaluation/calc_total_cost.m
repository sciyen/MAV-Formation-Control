function [formation_err, output_regulation, energy_efforts] = calc_total_cost(t, u, pos, params, formation, graph, dfc_opnash)
    formation_err = zeros(length(t), params.N);
    output_regulation = zeros(length(t), params.N);
    energy_efforts = zeros(length(t), params.N);
    for i = 1:params.N
        for j = 1:params.N
            if graph.adjacency(i, j) ~= 0
                % TODO:Ff
                err_i = vecnorm( ...
                    pos((i-1)*params.m+1:(i-1)*params.m+params.m, :) - ...
                    pos((j-1)*params.m+1:(j-1)*params.m+params.m, :) - ...
                    formation_displacement(i, j, params, formation), ...
                    2, 1);
                % formation_err = formation_err + graph.adjacency(i, j) * err_i';
                formation_err(:, i) = graph.adjacency(i, j) * err_i';
            end
        end

        % output regulation
        % TODO:Fo
        reg_i = vecnorm( ...
            pos((i-1)*params.m+1:i*params.m, :), 2, 1);
        % output_regulation = output_regulation + dfc_opnash.fi * reg_i';
        output_regulation(:, i) = dfc_opnash.fi * reg_i';

        % Energy efforts
        energy_i = vecnorm( ...
            u((i-1)*params.p+1:i*params.p, 2:end), 2, 1);
        delta_t = t(2:end) - t(1:end-1);
        % energy_efforts(2:end) = energy_efforts(2:end) + energy_i' .* delta_t / dfc_opnash.r(i,i);
        energy_efforts(2:end, i) = energy_i' .* delta_t / dfc_opnash.r(i,i);
    end
end
