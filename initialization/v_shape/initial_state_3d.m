% Initial states of agents
initial.state = zeros(params.N * params.n, 1);
for i = 1:params.N
    initial.state(get_pos_idx(i, params)) = [0 i i]';
    initial.state((i-1)*params.n + 4) = 2;
end