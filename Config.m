t = 0;                          % 初始时刻
N = 10;                         % 仿真步数 (10秒)
n = 1;                          % 状态维度
m = 1;                          % 控制维度
p = 1;                          % 噪声通道数

% 状态转移矩阵 
A = 1;

% 输入矩阵和增广输入矩阵
B = -3e-1;
D = 2e-1;
B_M = [B, D];

% 噪声系数矩阵和增广噪声系数矩阵
C = 0.01;
E = 4e-3;
F = 4e-3;
h = 0.1;
E_M = [E, F];

% 状态权重和均值项权重 (时间不一致性的来源)
Q = 1;
G = 10;
Q_bar = 0.1 * Q;
G_bar = 0.1 * G;

% 控制权重和均值项权重
R = 1;              
S = 1;              
R_bar = 0.1 * R;            
S_bar = 0.1 * S;            

Q_M = Q + Q_bar;
R_M = R + R_bar;
S_M = S + S_bar;
G_M = G + G_bar;
T_M = 0;
W_M = [R_M, T_M; T_M', -S_M];

% 噪声协方差矩阵
Gamma = 1;

save config t N n m A B_M Q Q_M G G_bar G_M W_M C E_M h Gamma;
