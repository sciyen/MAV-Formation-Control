function idx = get_pos_idx(agent_idx, params)
    idx = (agent_idx-1) * params.n+1 : (agent_idx-1) * params.n+params.m;
end
