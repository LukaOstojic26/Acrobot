using DifferentialEquations

include("acrobot_model!.jl")
include("animate_acrobot.jl")


function tau(t)
    y = 0
end

I1, I2, m1, m2, l1, l2, lc1, lc2 = (0.0083, 0.0083, 1, 1, 2, 2, 1, 1);
tspan = (0.0, 20.0);
x0 = [pi/4, 0.0, 0.0, 0.0];


param = (I1, I2, m1, m2, l1, l2, lc1, lc2, tau);
prob = ODEProblem(acrobot_model!, x0, tspan, param);
sol = solve(prob);

acrobot_animation(sol, x0, param)
