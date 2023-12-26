function Psi = state_trans(tf, t, model)
    Psi = expm(model.A * (tf - t));
end