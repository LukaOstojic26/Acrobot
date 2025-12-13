using Plots

include("acrobot_model!.jl")
include("control.jl")

function reaction_forces(sol, p)
    I1, I2, m1, m2, l1, l2, lc1, lc2, K = p;
    g = 9.81;
    m = m1 + m2

    G1 = I1 + m1*lc1^2 + m2*l1^2;
    G2 = I2 + m2*lc2^2;
    G3 = m2*l1*lc2;
    G4 = g*(m1*lc1 + m2*l1);
    G5 = m2*g*lc2;

    Fr = []

    for x in sol.u

        M = [0 0 1 0;
             0 0 0 1];
        T = [0;
             lqr_control(x, K)];  
        C = [(-2*G3*x[4]*sin(x[2])) (-G3*x[4]*sin(x[2]));
              G3*x[3]*sin(x[2])              0           ];
        G = [G4*cos(x[1]) + G5*cos(x[1] + x[2]);
                    G5*cos(x[1] + x[2])        ];
        H⁻¹ = (1/(G1*G2 - (G3^2)*(cos(x[2])^2))) .* [G2 (-G2 - G3*cos(x[2])); (-G2 - G3*cos(x[2])) (G1 + G2 + 2*G3*cos(x[2]))]; 
        Jc = [((-m1/m)*lc1*sin(x[1]) - (m2/m)*l1*sin(x[1]) - (m2/m)*lc2*sin(x[1] + x[2])) ((-m2/m)*lc2*sin(x[1] + x[2]));
              ((m1/m)*lc1*cos(x[1]) + (m2/m)*l1*cos(x[1]) + (m2/m)*lc2*cos(x[1] + x[2]))  ((m2/m)*lc2*cos(x[1] + x[2]))]
        Jc_d = [((-m1/m)*lc1*x[3]*cos(x[1]) - (m2/m)*l1*x[3]*cos(x[1]) - (m2/m)*lc2*(x[3] + x[4])*cos(x[1] + x[2])) ((-m2/m)*lc2*(x[3] + x[4])*cos(x[1] + x[2]));
                ((-m1/m)*lc1*x[3]*sin(x[1]) - (m2/m)*l1*x[3]*sin(x[1]) - (m2/m)*lc2*(x[3] + x[4])*sin(x[1] + x[2])) ((-m2/m)*lc2*(x[3] + x[4])*sin(x[1] + x[2]))]

        A = ((m.*Jc)*H⁻¹)
        B = (m.*(Jc_d - Jc*H⁻¹*C))*(M*x) - m.*(Jc*H⁻¹*G) - m.*[0; -g]
        
        F = A*T + B 

        push!(Fr, F)

    end


    return Fr

end