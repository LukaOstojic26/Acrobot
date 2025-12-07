using LinearAlgebra

function lqr_control(x, K)
    return tau = dot(-K, (x - [pi/2, 0, 0, 0]))
end

function lqr_control_saturation(dx, x, p)

    I1, I2, m1, m2, l1, l2, lc1, lc2, K = p;
    mi = 0.1
    eta = 0.1

    q1 = x[1]
    q2 = x[2]
    q1_d = x[3]
    q2_d = x[4]
    q1_dd = dx[3]
    q2_dd = dx[4]

    ac2x = -l1*q1_dd*sin(q1) - lc2*(q1_dd + q2_dd)*sin(q1 + q2) - l1*(q1_d ^ 2)*cos(q1) 
                                                                                    - lc2*((q1_d + q2_d)^2)*cos(q1 + q2)  
    ac2y = l1*q1_dd*cos.(q1) + lc2*(q1_dd + q2_dd)*cos(q1 + q2) - l1*(q1_d ^ 2)*sin(q1) 
                                                                                    - lc2*((q1_d + q2_d)^2)*sin(q1 + q2)
    ac1x = -lc1*(q1_d^2)*cos(q1)
    ac1y = -lc1*(q1_d^2)*sin(q1)

    A = 1 / (2 * cos(q1))
    B = A * (-2 * m2 * ac2x * sin(q1) - I1*q1_d + m1*9.81 * cos(q1) 
                                                                + m1*ac1y*cos(q1) + m1*ac1x*sin(q1))
    C = -1 / (sin(q1 + q2))
    D = m1*ac1x + C * (m2*ac2y*cos(q1 + q2) + m2*9.81 * cos(q1 + q2) + I2*(q1_d + q2_d))

    tau = dot(-K, (x - [pi/2, 0, 0, 0]))

    V1 = (-mi*B-D)/(C + mi*A)
    V2 = (mi*B-D)/(C - mi*A)
    V3 = (eta - B)/A

    m = min(V1, V2)
    M = max(V1, V2)

    if V3 < M && V3 > m
        m = V3
    end

    if tau < M && tau > m
        return tau
    else
        sat = [m, M][argmin([abs(m-tau), abs(M-tau)])]
        return sat
    end


end