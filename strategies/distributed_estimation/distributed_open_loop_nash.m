function u = distributed_open_loop_nash(t, x, y_hat, params, formation, model, graph, dfc_opnash)
    u = zeros(params.N * params.p, 1);

    for i = 1:params.N 
        sum_neighbors_y_hat = distributed_error_helper(i, y_hat, params, graph, formation, dfc_opnash);

        ui = - dfc_opnash.r(i, i) * dfc_opnash.R \ model.B' * state_trans(params.T, t, model)' * ...
            model.C' * sum_neighbors_y_hat;
            
        u((i - 1) * params.p + 1:i * params.p) = ui;
    end
end