function acrobot_model!(dx, x, p, t)
    I1, I2, m1, m2, l1, l2, lc1, lc2 = p;
    g = 9.81;

    G1 = I1 + m1*lc1^2 + m2*l1^2;
    G2 = I2 + m2*lc2^2;
    G3 = m2*l1*lc2;
    G4 = g*(m1*lc1 + m2*l1);
    G5 = m2*g*lc2;
    J1 = (G2*(G1 + G2 + 2*G3*cos(x[2])) - (G2 + G3*cos(x[2]))^2)/(G2*(G1 + G2 + 2*G3*cos(x[2])));
    J2 = ((G2 + G3*cos(x[2]))*G3*x[3]*sin(x[2]) + 2*G2*G3*x[4]*sin(x[2]))/(G2*(G1 + G2 + 2*G3*cos(x[2])));
    J3 = (G3*x[4]*sin(x[2]))/(G1 + G2 + 2*G3*cos(x[2]));
    J4 = ((G2 + G3*cos(x[2]))*G5*cos(x[1] + x[2]) - G2*(G4*cos(x[1]) + G5*cos(x[1] + x[2])))/(G2*(G1 + G2 + 2*G3*cos(x[2])));
    J5 = -(G2 + G3*cos(x[2]))/(G2*(G1 + G2 + 2*G3*cos(x[2])));
    Y1 = -((G2 + G3*cos(x[2]))*J2 + J1*G3*x[3]*sin(x[2]))/(G2*J1);
    Y2 = -((G2 + G3*cos(x[2]))*J3)/(G2*J1);
    Y3 = -((G2 + G3*cos(x[2]))*J4 + J1*G5*cos(x[1] + x[2]))/(G2*J1);
    Y4 = (J1 - (G2 + G3*cos(x[2]))*J5)/(G2*J1);

    dx[1] = x[3]
    dx[2] = x[4]
    dx[3] = (J2/J1)*x[3] + (J3/J1)*x[4] + J4/J1 + (J5/J1)*0; #(J5/J1)*tau
    dx[4] = Y1*x[3] + Y2*x[4] + Y3 + Y4*0; # Y4*tau

end



