using DifferentialEquations
using ControlSystems

include("acrobot_model!.jl")
include("animate_acrobot.jl")
include("linear_acrobot.jl")


I1, I2, m1, m2, l1, l2, lc1, lc2 = (0.0083, 0.0083, 1, 1, 2, 2, 1, 1);
tspan = (0.0, 20.0);
x0 = [pi/2 - 0.01, 0.0, 0.0, 0.0];

#                        I1      I2    m1  m2  l1  l2  lc1 lc2
A, B = linear_acrobot((0.0083, 0.0083, 1,  1,  2,  2,  1,  1))

Q = [10.0 0.0 0.0 0.0;
     0.0 10.0 0.0 0.0;
     0.0 0.0 1.0 0.0;
     0.0 0.0 0.0 1.0];

R = 1;

K = lqr(Continuous, A, B, Q, R)

param = (I1, I2, m1, m2, l1, l2, lc1, lc2, K);
prob = ODEProblem(acrobot_model!, x0, tspan, param);
sol = solve(prob);

#acrobot_animation(sol, x0, param)
