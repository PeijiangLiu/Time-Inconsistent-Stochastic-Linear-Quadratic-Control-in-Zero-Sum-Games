function [state_evolution]=Dynamics(state,strategy,omega)
    %导入配置
    load config.mat 
    eta = (C*state + E_M*strategy + h)*omega;
    state_evolution = A*state + B_M*strategy + eta;
end
