function [dy_hat, etc] = final_position_estimator(y_hat, params, initial, model, graph, formation, dfc_opnash)
    % dy_hat = zeros(params.N * params.m, 1);
    dy_hat = y_hat * 0;
    etc = y_hat * 0;

    for i = 1:params.N
        x0 = initial.state((i-1)*params.n+1 : i*params.n);
        self_y_hat = y_hat((i-1)*params.m+1 : i*params.m);

        sum_neighbors_y_hat = distributed_error_helper(i, y_hat, params, graph, formation, dfc_opnash);
        
        dyi_hat = dfc_opnash.gi * ( model.C * state_trans(params.T, params.t0, model) * x0 - self_y_hat - ... 
            dfc_opnash.r(i, i) * dfc_opnash.D_bar_t2t1 * sum_neighbors_y_hat);
    
        dy_hat((i-1)*params.m+1 : i*params.m) = dyi_hat;
        etc((i-1)*params.m+1 : i*params.m, 1) = sum_neighbors_y_hat;
    end
end