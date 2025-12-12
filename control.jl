using LinearAlgebra

function lqr_control(x, K)
    return tau = dot(-K, (x - [pi/2, 0, 0, 0]))
end
