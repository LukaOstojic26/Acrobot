using Plots

include("acrobot_model!.jl")

function x_dot(sol, p)
    dx = []
    for (ti, ui) in zip(sol.t, sol.u)
        du = similar(ui)
        acrobot_model!(du, ui, p, ti)
        push!(dx, du)
    end

    return dx
end

function reaction_forces(sol, p)
    I1, I2, m1, m2, l1, l2, lc1, lc2, K = p;
    dx = x_dot(sol, p)

    q1 = [el[1] for el in sol.u]
    q2 = [el[2] for el in sol.u]
    q1_d = [el[3] for el in sol.u]
    q2_d = [el[4] for el in sol.u]
    q1_dd = [el[3] for el in dx]
    q2_dd = [el[4] for el in dx]


    ac2x = -l1.*q1_dd.*sin.(q1) .- lc2.*(q1_dd .+ q2_dd).*sin.(q1 .+ q2) .- l1.*(q1_d .^ 2).*cos.(q1) 
                                                                                    .- lc2.*((q1_d .+ q2_d).^2).*cos.(q1 .+ q2)  
    ac2y = l1.*q1_dd.*cos.(q1) .+ lc2.*(q1_dd .+ q2_dd).*cos.(q1 .+ q2) .- l1.*(q1_d .^ 2).*sin.(q1) 
                                                                                    .- lc2.*((q1_d .+ q2_d).^2).*sin.(q1 .+ q2)
    ac1x = -lc1.*(q1_d.^2).*cos.(q1)
    ac1y = -lc1.*(q1_d.^2).*sin.(q1)

    A = 1 ./ (2 .* cos.(q1))
    B = A .* (-2 .* m2 .* ac2x .* sin.(q1) .- I1.*q1_d .+ m1.*9.81 .* cos.(q1) 
                                                                .+ m1.*ac1y.*cos.(q1) .+ m1.*ac1x.*sin.(q1))
    C = -1 ./ (sin.(q1 .+ q2))
    D = m1.*ac1x .+ C .* (m2.*ac2y.*cos.(q1 .+ q2) .+ m2*9.81 .* cos.(q1 .+ q2) + I2.*(q1_d .+ q2_d))

    x = [ [w, i, y, z] for (w, i, y, z) in zip(q1, q2, q1_d, q2_d)]

    tau = []
    for xi in x 
        tau_i = dot(-K, xi - [pi/2, 0, 0, 0])
        push!(tau, tau_i)
    end

    Fx = C .* tau .+ D
    Fy = A .* tau .+ B

    Plots.plot(sol.t, [Fx Fy], title="Sile reakcije", label=["Fx" "Fy"], linewidth=3, ylims=(-30, 31))

end