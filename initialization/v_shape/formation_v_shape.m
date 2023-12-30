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
formation.theta = 2 * pi / 3;
formation.R = 2.5 * formation.l;

% desired distance between two agents
formation.desired_pos = zeros(params.N * params.m, 1);

for i=1:params.N
    % x y z
    dx = abs(i - (params.N + 1) / 2) * formation.l * cos(formation.theta);
    dy = (i - (params.N + 1) / 2) * formation.l * sin(formation.theta);
    formation.desired_pos((i-1)*params.m+1 : i*params.m) = [dx dy 0];
end