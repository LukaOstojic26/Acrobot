using GLMakie

function xycoords(state, p)
    l1 = p[5]
    l2 = p[6]
    θ1 = state[1]
    θ2 = state[2]
    x1 = l1 * sin(θ1)
    y1 = -l1 * cos(θ1)
    x2 = x1 + l2 * sin(θ2)
    y2 = y1 - l2 * cos(θ2)
    return x1,x2,y1,y2
end

function acrobot_animation(t, u, u0, p)

    fig = Figure(); display(fig)
    ax = Axis(fig[1,1])

    circle = Observable{Any}(0.0);
    rod = Observable{Any}(0.0);

    for i in t
        x1, x2, y1, y2 = xycoords(u, p)

        circle[] = [Point2f(x1, y1), Point2f(x2, y2)]
        rod[] = [Point2f(0, 0), Point2f(x1, y1), Point2f(x2, y2)]

        lines!(ax, rod; linewidth = 4, color = :purple)
        scatter!(ax, balls; marker = :circle, strokewidth = 2, 
        strokecolor = :purple,
        color = :black, markersize = [8, 12]
        )
        
    end

end

