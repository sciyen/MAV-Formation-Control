function [dx, y] = agent_model(x, u, model)
    % double integrator model in 3D space
    % x = [x, y, z, vx, vy, vz]
    % u = [ax, ay, az]
    dx = model.A * x + model.B * u;
    y = model.C * x + model.D * u;
end