include("control.jl")

function acrobot_model!(dx, x, p, t)
    I1, I2, m1, m2, l1, l2, lc1, lc2, K = p;
    g = 9.81;

    G1 = I1 + m1*lc1^2 + m2*l1^2;
    G2 = I2 + m2*lc2^2;
    G3 = m2*l1*lc2;
    G4 = g*(m1*lc1 + m2*l1);
    G5 = m2*g*lc2;

    M = [0 0 1 0;
         0 0 0 1];
    T = [0;
         lqr_control(x, K)];  
    #T = [0;
    #     lqr_control_saturation(dx, x, p)]
    C = [(-2*G3*x[4]*sin(x[2])) (-G3*x[4]*sin(x[2]));
          G3*x[3]*sin(x[2])              0           ];
    G = [G4*cos(x[1]) + G5*cos(x[1] + x[2]);
                G5*cos(x[1] + x[2])        ];
    H⁻¹ = (1/(G1*G2 - (G3^2)*(cos(x[2])^2))) .* [G2 (-G2 - G3*cos(x[2])); (-G2 - G3*cos(x[2])) (G1 + G2 + 2*G3*cos(x[2]))]; 

    p1 = M*x;
    p2 = H⁻¹*(T - C*(M*x) - G);

    dx[1] = p1[1] 
    dx[2] = p1[2]
    dx[3] = p2[1] 
    dx[4] = p2[2] 

end



