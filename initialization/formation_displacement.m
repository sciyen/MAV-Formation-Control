function mu = formation_displacement(i, j, params, formation)
    mu = formation.desired_pos((i-1)*params.m+1 : i*params.m) ...
        - formation.desired_pos((j-1)*params.m+1 : j*params.m);
end