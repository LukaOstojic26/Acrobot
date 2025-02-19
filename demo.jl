using DifferentialEquations

include("acrobot_model!.jl")

using GLMakie

function xycoords(state, p)
    l1 = p[5]
    l2 = p[6]
    θ1 = state[1]
    θ2 = state[2]
    x1 = l1 * cos(θ1)
    y1 = l1 * sin(θ1)
    x2 = x1 + l2 * cos(θ1 + θ2)
    y2 = y1 + l2 * sin(θ1 + θ2)
    return x1,x2,y1,y2
end

function acrobot_animation(sol, u0, p)

    u1 = [el[1] for el in sol.u]
    u2 = [el[2] for el in sol.u]
    u3 = [el[3] for el in sol.u]
    u4 = [el[4] for el in sol.u]
    time = sol.t

    fig = Figure(); display(fig)
    ax = Axis(fig[1,1])

    x1, x2, y1, y2 = xycoords(u0, p)

    lines!(ax, [0, x1], [0, y1])
    lines!(ax, [x1, x2], [y1, y2], color = :tomato)
    scatter!(ax, x1, y1, markersize=10)
    scatter!(ax, x2, y2, markersize=10, color = :tomato)

    xlims!(ax, -5, 5)
    ylims!(ax, -5, 5)
    limits!(ax, -5, 5, -5, 4)

    for i in 1:length(time)
        x1, x2, y1, y2 = xycoords([u1[i], u2[i]], p)

        lines!(ax, [0, x1], [0, y1])
        lines!(ax, [x1, x2], [y1, y2], color = :tomato)
        scatter!(ax, x1, y1, markersize=10)
        scatter!(ax, x2, y2, markersize=10, color = :tomato)

        sleep(0.01)
        empty!(ax)

    end

end

function tau_func(t)
    y = 0
end

I1, I2, m1, m2, l1, l2, lc1, lc2 = (0.0083, 0.0083, 1, 1, 2, 2, 1, 1);
tspan = (0.0, 20.0);
x0 = [pi/4, 0.0, 0.0, 0.0];

param = (I1, I2, m1, m2, l1, l2, lc1, lc2);
prob = ODEProblem(acrobot_model!, x0, tspan, param);
sol = solve(prob);

acrobot_animation(sol, x0, param)
