function linear_acrobot(p)
    I1, I2, m1, m2, l1, l2, lc1, lc2 = p;
    g = 9.81;

    G1 = I1 + m1*lc1^2 + m2*l1^2;
    G2 = I2 + m2*lc2^2;
    G3 = m2*l1*lc2;
    G4 = g*(m1*lc1 + m2*l1);
    G5 = m2*g*lc2;

    A = [                        0                                     0                1 0;
                                 0                                     0                0 1;
                  (G2*G4 - G3*G5)/(G1*G2 - G3^2)           (-G3*G5)/(G1*G2 - G3^2)      0 0;
         (G5*(G1 + G3) - G4*(G2 + G3))/(G1*G2 - G3^2)   (G5*(G1 + G3))/(G1*G2 - G3^2)   0 0];

    B = [0;
         0;
         (-G2 - G3)/(G1*G2 - G3^2);
         (G1 + G2 + 2*G3)/(G1*G2 - G3^2)];

    return A, B

end