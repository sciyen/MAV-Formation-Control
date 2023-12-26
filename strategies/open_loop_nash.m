function u = open_loop_nash(t, x, params, initial, model, graph, dfc_opnash)
    u = zeros(params.N * params.p, 1);

    Phi_C = kron(eye(params.N), model.C * state_trans(params.T, params.t0, model));
    W = (-dfc_opnash.mu + (dfc_opnash.F + kron(graph.laplacian, dfc_opnash.Ff)) / dfc_opnash.H_t2t1 * ...
            (Phi_C * initial.state + dfc_opnash.D_t2t1 * dfc_opnash.mu));

    for i = 1:params.N 
        ei = zeros(params.N, 1);
        ei(i) = 1;

        ui = - dfc_opnash.r(i, i) * dfc_opnash.R \ model.B' * state_trans(params.T, t, model)' * ...
            model.C' * kron(ei', eye(params.m)) * W;
            
        u((i - 1) * params.p + 1:i * params.p) = ui;
    end
end