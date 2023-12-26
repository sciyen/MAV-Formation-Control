% ====================================================================
% Distributed Formation Control with Open-Loop Nash Strategy
% ====================================================================
dfc_opnash = struct();

% Energy effort weight
dfc_opnash.R = eye(params.p);

% Team energy effort weight
dfc_opnash.r = eye(params.N);

% Formation error weight, pxp
dfc_opnash.Ff = eye(params.m);

% Output regulation weight, pxp
dfc_opnash.Fo = eye(params.m);

dfc_opnash.fi = 0.01;

% Team error output regulation weight, nxn
dfc_opnash.F = kron(dfc_opnash.fi * eye(params.N), dfc_opnash.Fo);

% The state transition matrix Psi(t_f, t)
% state_trans = @(t) expm(model.A * (params.T - t));

fun = @(t) state_trans(params.T, t, model) * model.B / dfc_opnash.R * model.B' * state_trans(params.T, t, model)';
W_t2t1 = integral(fun, params.t0, params.T, 'ArrayValued', true);
dfc_opnash.D_bar_t2t1 = model.C * W_t2t1 * model.C';

dfc_opnash.D_t2t1 = kron(dfc_opnash.r, dfc_opnash.D_bar_t2t1);

dfc_opnash.H_t2t1 = eye(params.N * params.m) + dfc_opnash.D_t2t1 * (dfc_opnash.F + kron(graph.laplacian, dfc_opnash.Ff));

dfc_opnash.mu = zeros(params.N * params.m, 1);
for i = 1:params.N
    mu_ij = 0;
    for j = 1:params.N
        if graph.adjacency(i, j) ~= 0
            % j is i's neighbor
            mu_ij = mu_ij + graph.adjacency(i, j) * dfc_opnash.Ff * formation_displacement(i, j, params, formation);
        end
    end
    dfc_opnash.mu((i-1)*params.m+1 : i*params.m) = mu_ij;
end