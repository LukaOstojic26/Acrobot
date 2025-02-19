using DifferentialEquations
using Plots
theme(:rose_pine_dawn::Symbol;)

f(u, p, t) = cos(t)
u0 = 0.0
tspan = (0.0, 10.0)

prob = ODEProblem(f, u0, tspan);
sol = solve(prob)

plot(sol)
