% ====================================================================
% Initialization of parameters
% ====================================================================
% Exporting: 
%    - params: parameters of the system
%    - formation: definition of V-shape formation
%    - initial: initial states of agents
%    - graph: communication topology among agents


params = struct();
% number of agents
params.N = 11;

% dimension of states per agent
params.n = size(model.A, 1);

% dimension of output per agent
params.m = size(model.C, 1);

% dimension of control per agent
params.p = size(model.B, 2);

params.t0 = 0;
params.T = 20;

% ====================================================================
% definition of V-shape formation
% ====================================================================

%      +     ----------
%     - -     \  theta
%    +   +     \
%   -     -
%  +       +

formation = struct();
% distance between two consecutive agents
formation.l = 5;

% angle of the V-shape formation
formation.theta = pi / 6;
formation.R = 2.5 * formation.l;

% Initial states of agents
initial.state = zeros(params.N * params.n, 1);

% desired distance between two agents
formation.desired_pos = zeros(params.N * params.m, 1);

for i=1:params.N
    % x y z
    dx = abs(i - (params.N + 1) / 2) * formation.l * sin(formation.theta);
    dy = (i - (params.N + 1) / 2) * formation.l * cos(formation.theta);
    formation.desired_pos((i-1)*params.m+1 : i*params.m) = [dx dy 0];
    initial.state(get_pos_idx(i, params)) = [dx dy-10 0]';
end

% ====================================================================
% Communication topology among agents
% ====================================================================

graph = struct();
% Kai Li, Ruiyan Gong, Sentang Wu, Changqing Hu, and Ying Wang, 
% “Decentralized Robust Connectivity Control in Flocking of Multi-Robot Systems,” 
% IEEE Access, Vol. 8, pp. 105250–105262, 2020.

graph.adjacency = zeros(params.N);
for i=1:params.N
    for j=1:params.N
        if i == j
            continue;
        end
        % is neighbor
        if abs(i - j) <= 2
            pos_err_norm = norm(initial.state(get_pos_idx(i, params)) - initial.state(get_pos_idx(j, params)));
            graph.adjacency(i, j) = exp((formation.R^2 - pos_err_norm^2) / (2 * formation.R^2 / (2 * log(2))));
        end
    end
end

graph.degree = zeros(params.N);
for i=1:params.N
    graph.degree(i, i) = sum(graph.adjacency(i, :));
end

% weighted Laplacian matrix
graph.laplacian = graph.degree - graph.adjacency;

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

% Team error output regulation weight, nxn
dfc_opnash.F = kron(eye(params.N), dfc_opnash.Fo);

% The state transition matrix Psi(t_f, t)
% state_trans = @(t) expm(model.A * (params.T - t));

fun = @(t) state_trans(params.T, t, model) * model.B / dfc_opnash.R * model.B' * state_trans(params.T, t, model)';
W_t2t1 = integral(fun, params.t0, params.T, 'ArrayValued', true);
dfc_opnash.D_bar_t2t1 = model.C * W_t2t1 * model.C';

dfc_opnash.D_t2t1 = kron(dfc_opnash.r, dfc_opnash.D_bar_t2t1);

dfc_opnash.H_t2t1 = eye(params.N * params.m) + dfc_opnash.D_t2t1 * (dfc_opnash.F + kron(dfc_opnash.Ff, graph.laplacian));

dfc_opnash.mu = zeros(params.N * params.m, 1);
for i = 1:params.N
    mu_ij = 0;
    for j = 1:params.N
        if graph.adjacency(i, j) ~= 0
            % j is i's neighbor
            mu_ij = mu_ij - graph.laplacian(i, j) * dfc_opnash.Ff * formation_displacement(i, j, params, formation);
        end
    end
    dfc_opnash.mu((i-1)*params.m+1 : i*params.m) = mu_ij;
end

% ====================================================================
% Helper functions
% ====================================================================
