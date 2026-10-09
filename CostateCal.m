%%计算P
function [M_for,M_M_for,c_for] = CostateCal(gain,cons,M,M_M,c)
load config.mat
    M_for = Q + A'*M*(A-B_M*gain) + Gamma*C'*M*(C-E_M*gain);
    M_M_for = Q_M + A'*M_M*(A-B_M*gain) + Gamma*C'*M*(C-E_M*gain);
    c_for = A'*(c-M_M*B_M*cons) + Gamma*C'*M*(h-E_M*cons);
end