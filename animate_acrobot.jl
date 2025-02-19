using GLMakie
using DataStructures: CircularBuffer

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
    time = sol.t

    fig = Figure(); display(fig)
    ax = Axis(fig[1,1])

    x1, x2, y1, y2 = xycoords(u0, p)

    circle = Observable([Point2f(x1, y1), Point2f(x2, y2)])
    rod = Observable([Point2f(0, 0), Point2f(x1, y1), Point2f(x2, y2)])

    tail = 300 

    traj = CircularBuffer{Point2f}(tail)
    fill!(traj, Point2f(x2, y2)) 
    traj = Observable(traj) 

    lines!(ax, rod; linewidth = 4, color = :sienna3)
    scatter!(ax, circle; marker = :circle, strokewidth = 2, 
                                         strokecolor = :sienna3,
                                            color = :black, markersize = [8, 12])

    c = to_color(:sienna3)
    tailcol = [RGBAf(c.r, c.g, c.b, (i/tail)^20) for i in 1:tail]
    lines!(ax, traj; linewidth = 3, color = tailcol)

    xlims!(ax, -1.05*(p[5]+ p[6]), 1.05*(p[5]+ p[6]))
    ylims!(ax, -1.05*(p[5]+ p[6]), 1.05*(p[5]+ p[6]))
    limits!(ax, -1.05*(p[5]+ p[6]), 1.05*(p[5]+ p[6]), -1.05*(p[5]+ p[6]), 1.05*(p[5]+ p[6]))

    for i in 1:length(time)
        x1, x2, y1, y2 = xycoords([u1[i], u2[i]], p)

        rod[] = [Point2f(0, 0), Point2f(x1, y1), Point2f(x2, y2)]
        circle[] = [Point2f(x1, y1), Point2f(x2, y2)]
        push!(traj[], Point2f(x2, y2))
        traj[] = traj[]
        sleep(0.05)

    end

end

