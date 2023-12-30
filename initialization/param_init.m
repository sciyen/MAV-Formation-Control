% ====================================================================
% Initialization of parameters
% ====================================================================
% Exporting: 
%    - params: parameters of the system
%    - formation: definition of V-shape formation
%    - initial: initial states of agents
%    - graph: communication topology among agents

% run('model_dfc_automatica.m')
run('model_init.m')

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

% run('formation_dfc_automatica.m')
% run('initial_state_dfc_automatica.m')

run('formation_v_shape.m')
run('initial_state_3d.m')

initial.pos = kron(eye(params.N), [eye(3) zeros(3)]) * initial.state;

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
        if abs(i - j) <= 3
            pos_err_norm = norm(initial.state(get_pos_idx(i, params)) - initial.state(get_pos_idx(j, params)));
            graph.adjacency(i, j) = exp((formation.R^2 - pos_err_norm^2) / (2 * formation.R^2 / (2 * log(2)))) - 1;
            % graph.adjacency(i, j) = 1;
        end
    end
end
% graph.adjacency = ... 
% [0 0 0;
%  1 0 0;
%  1 0 0];

graph.degree = zeros(params.N);
for i=1:params.N
    graph.degree(i, i) = sum(graph.adjacency(i, :));
end

% weighted Laplacian matrix
graph.laplacian = graph.degree - graph.adjacency;

