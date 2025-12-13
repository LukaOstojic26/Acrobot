using LinearAlgebra

function satisfies_conditions(x, conditions)
    interval = []
    for i in x
        if all(cond(i) for cond in conditions)
            push!(interval, i)
        end
    end

    return interval
end

function lqr_control(x, K)
    return tau = dot(-K, (x - [pi/2, 0, 0, 0]))
end

function lqr_with_saturation(x, p)
    I1, I2, m1, m2, l1, l2, lc1, lc2, K = p;
    g = 9.81;
    m = m1 + m2

    G1 = I1 + m1*lc1^2 + m2*l1^2;
    G2 = I2 + m2*lc2^2;
    G3 = m2*l1*lc2;
    G4 = g*(m1*lc1 + m2*l1);
    G5 = m2*g*lc2;

    tau = lqr_control(x, K)

    M = [0 0 1 0;
         0 0 0 1];
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

    #=
    A i B su matrice za racunanje sile reakcije podloge na prvi segment akrobota
    preko jednacine F = A*T + B 
    =#

    epsilon = 1 # Fy treba biti veca od nekog pozitivnog broja (=~ 1)
    mi = 1 # Koeficijent trenja

    v1 = (epsilon - B[2])/A[2, 2]
    v2 = (-mi*B[2] - B[1])/(A[1, 2] + mi*A[2, 2])
    v3 = (mi*B[2] - B[1])/(A[1, 2] + mi*A[2, 2])

    vrednosti = Dict(
        v1 => "v1", 
        v2 => "v2", 
        v3 => "v3",
        tau => "tau" 
    )

    v = sort([v1, v2, v3, tau])

    
    if A[2, 2] > 0
        if (A[1, 2] + mi*A[2, 2]) > 0
            if(A[1, 2] - mi*A[2, 2]) > 0
                nejednakosti = [t -> t >= v1, t -> t >= v2, t -> t <= v3]
            else
                nejednakosti = [t -> t >= v1, t -> t >= v2, t -> t >= v3]
            end
        else
            if(A[1, 2] - mi*A[2, 2]) > 0
                nejednakosti = [t -> t >= v1, t -> t <= v2, t -> t <= v3]
            else
                nejednakosti = [t -> t >= v1, t -> t <= v2, t -> t >= v3]
            end
        end
    else
        if (A[1, 2] + mi*A[2, 2]) > 0
            if(A[1, 2] - mi*A[2, 2]) > 0
                nejednakosti = [t -> t <= v1, t -> t >= v2, t -> t <= v3]
            else
                nejednakosti = [t -> t <= v1, t -> t >= v2, t -> t >= v3]
            end
        else
            if(A[1, 2] - mi*A[2, 2]) > 0
                nejednakosti = [t -> t <= v1, t -> t <= v2, t -> t <= v3]
            else
                nejednakosti = [t -> t <= v1, t -> t <= v2, t -> t >= v3]
            end
        end
    end
    
    interval = satisfies_conditions([v1, v2, v3], nejednakosti)

    if length(interval) == 2 
        max = maximum(interval)
        min = minimum(interval)
        if tau >= min && tau <= max
            return tau
        elseif tau < min
            return min
        elseif tau > max
            return max
        end
    elseif length(interval) == 1
        if tau >= interval[1]
            return tau
        else
            return interval[1]
        end
    else
        return tau
    end


end
