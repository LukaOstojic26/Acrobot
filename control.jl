function lqr_control(x, K)
    return tau = -K*(x - [pi/2, 0, 0, 0])
end