using DifferentialEquations
using ControlSystems
using Plots

include("acrobot_model!.jl")
include("animate_acrobot.jl")
include("linear_acrobot.jl")
include("reaction_forces.jl")


I1, I2, m1, m2, l1, l2, lc1, lc2 = (0.00192579089, 0.0281182992, 0.34111236, 2.1601915299999996, 0.3375, 0.4087, 0.240403710, 0.211247879);
tspan = (0.0, 20.0);
x0 = [pi/2 - 0.01, 0.0, 0.0, 0.0];

#                        I1      I2    m1  m2  l1  l2  lc1 lc2
A, B = linear_acrobot((I1, I2, m1,  m2,  l1,  l2,  lc1,  lc2))

Q = [10.0 0.0 0.0 0.0;
     0.0 10.0 0.0 0.0;
     0.0 0.0 1.0 0.0;
     0.0 0.0 0.0 1.0];

R = 1;

K = lqr(Continuous, A, B, Q, R)

param = (I1, I2, m1, m2, l1, l2, lc1, lc2, K);
prob = ODEProblem(acrobot_model!, x0, tspan, param);
sol = solve(prob);

####### Plotovanje sile reakcije #######
Fr = reaction_forces(sol, param)

Frx = [row[1] for row in Fr]
Fry = [row[2] for row in Fr]

Plots.plot(sol.t, Frx, label="Fx", color=:blue, linewidth=3)
Plots.plot!(sol.t, Fry, label="Fy", color=:red, linewidth=3)
########################################

#acrobot_animation(sol, x0, param)
