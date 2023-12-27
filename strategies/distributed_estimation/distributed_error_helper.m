function out = distributed_error_helper(i, y_hat, params, graph, formation, dfc_opnash)
    self_y_hat = y_hat((i-1)*params.m+1 : i*params.m);

    % Estimation of y_hat
    sum_neighbors_y_hat = zeros(params.m, 1);
    for j = 1:params.N
        if graph.adjacency(i, j) ~= 0
            j_y_hat = y_hat((j-1)*params.m+1 : j*params.m);
            mu_ij = formation_displacement(i, j, params, formation);
            sum_neighbors_y_hat = sum_neighbors_y_hat + ...
                graph.adjacency(i, j) * dfc_opnash.Ff * (self_y_hat - j_y_hat - mu_ij);
        end
    end

    out = dfc_opnash.fi * dfc_opnash.Fo * self_y_hat + sum_neighbors_y_hat;
end