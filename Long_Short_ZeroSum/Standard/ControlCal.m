function [Gain,Cons]=ControlCal(M,M_M,c)
load config.mat
    H_M = W_M + B_M'*M_M*B_M + Gamma*E_M'*M*E_M;
    L_M = B_M'*M_M*A + Gamma*E_M'*M*C;
    N_M = B_M'*c + Gamma*E_M'*M*h;
    Gain = pinv(H_M)*L_M;
    Cons = pinv(H_M)*N_M;
end