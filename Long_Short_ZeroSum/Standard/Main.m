clc;clear;close all;
load config.mat
%% 初始化
rng(49);                                       % 随机数种子
x0 = 10;                                       % 初始状态
n_sim = 500;                                   % 仿真轮数
omega_sequence = sqrt(Gamma)*randn(n_sim,N);   % 噪声序列
X = zeros(n_sim,N+1);                          % 状态序列
U = zeros(n_sim, N);                           % 玩家一控制序列
V = zeros(n_sim, N);                           % 玩家二控制序列
gain_sequence = cell(1,N);                     % 增益序列
cons_sequence = cell(1,N);                     % 常数序列
gain_plot = zeros(2,N);
cons_plot = zeros(2,N);
%% 计算增益和常数
for i=N-1:-1:t
    M=G;M_M=G_M;c=zeros(n,1);
    if i<N-1
        for j=N-2:-1:i
            index=N-2-j;
            gain=gain_sequence{end-index};
            cons=cons_sequence{end-index};
            [M,M_M,c]=CostateCal(gain,cons,M,M_M,c);
        end
    end
    [gain,cons]=ControlCal(M,M_M,c);
    gain_sequence{i+1}=gain;
    cons_sequence{i+1}=cons;
    disp(i);
end
%% 仿真
for sim = 1:n_sim
    X(sim,1) = x0;
    for i = t+1:N
        index = i-t;
        gain = gain_sequence{index};
        cons = cons_sequence{index};
        x = X(sim,index);
        omega = omega_sequence(sim,index);
        pi = -gain*x-cons;
        U(sim,index) = pi(1:m,1);
        V(sim,index) = pi(m+1:end,1);
        x=Dynamics(x,pi,omega);
        X(sim,index+1)=x;
        gain_plot(:,i) = gain;
        cons_plot(:,i) = cons;
    end
end


% for i=t+1:N
%     index=i-t;
%     gain=gain_sequence{index};
%     cons=cons_sequence{index};
%     x=X(:,index);
%     omega=omega_sequence(:,index);
%     pi=-gain*x-cons;
%     U(:,index) = pi(1:m,1);
%     V(:,index) = pi(m+1:end,1);
%     x=Dynamics(x,pi,omega);
%     X(:,index+1)=x;
% end

figure(1)
u_time=t:N-1;
plot(u_time,gain_plot(1,u_time+1),'-o',LineWidth=1.5);hold on
plot(u_time,gain_plot(2,u_time+1),'-o',LineWidth=1.5);
set(gca, 'FontSize', 20);
xticks(u_time);
xlim([t,N-1]);
yticks(-2:0.2:-0.8);
ylim([-2,-0.8]);
xlabel('$k$','interpreter','latex','FontSize',20);
ylabel('$\Theta_k$','interpreter','latex','FontSize',20);
lgd=legend('$\Theta_{k,1}$','$\Theta_{k,2}$','FontSize',20,'Interpreter','latex','location','Best');
set(gcf,'paperpositionmode','auto');
% print('-depsc','..\Fig\Theta.eps')
figure(2)
set(gca, 'FontSize', 20);
plot(u_time,cons_plot(1,u_time+1),'-o',LineWidth=1.5);hold on
plot(u_time,cons_plot(2,u_time+1),'-o',LineWidth=1.5);
set(gca, 'FontSize', 20);
xticks(u_time);
xlim([t,N-1]);
xlabel('$k$','interpreter','latex','FontSize',20);
ylabel('$\psi_k$','interpreter','latex','FontSize',20);
lgd=legend('$\psi_{k,1}$','$\psi_{k,2}$','FontSize',20,'Interpreter','latex','location','Best');
set(gcf,'paperpositionmode','auto');
% print('-depsc','..\Fig\psi.eps')
% figure(3)
% x_time=t:N;
% plot(x_time,X(1,x_time+1),'-o',LineWidth=1.5)
% plot(u_time,U(:,u_time+1),'-o',LineWidth=1.5);hold on
% plot(u_time,V(:,u_time+1),'-o',LineWidth=1.5);
% for i=t:N
%     J=0;
%     if i<N
%         for j=i:N-1
%             index=j-t+1;
%             x=x_plot(:,index);
%             upsilon=upsilon_plot(:,index);
%             varphi=varphiCal(i,j);
%             J=J+varphi*(x'*Q*x+upsilon'*R*upsilon);
%         end
%         varphi_end=varphiCal(i,N);
%         x_end=x_plot(:,end);
%         J=J+varphi_end*(x_end'*G*x_end);
%     else
%         varphi_end=varphiCal(i,N);
%         x_end=x_plot(:,end);
%         J=J+varphi_end*(x_end'*G*x_end);
%     end
%     J_plot=[J_plot J];
% end
% 
% for i=t:N
%     index=i-t+1;
%     if i<N
%         x=x_plot(:,index);
%         upsilon=upsilon_plot(:,index);
%         E=x'*Q*x+upsilon'*R*upsilon;
%     else
%         x=x_plot(:,index);
%         E=x'*G*x;
%     end
%     E_plot=[E_plot E];
% end



%%
% figure(1)
% time=t:N;
% plot(time,x_plot(1,time+1),'-o',LineWidth=1.5)
% figure(2)
% plot(time,x_plot(2,time+1),'-o',LineWidth=1.5)
% figure(3)
% plot(time,J_plot(time+1),'-o',LineWidth=1.5)
% figure(4)
% plot(time,E_plot(time+1),'-o',LineWidth=1.5)
%%
% ENorm_Plot=vecnorm(E_Plot);
% Etime=0:50;
% DEnd=15;
% Dtime=0:DEnd;
% y1Norm_Plot=vecnorm(y_1);
% y0Norm_Plot=vecnorm(y_0);
% plot(y_1(1,:))
% hold on
% plot(y_0(1,:))
% figure(1)
% plot(Etime,ENorm_Plot(1,Etime+1),'r',LineWidth=1.5);
% xlabel('$k$','interpreter','latex','FontSize',12);
% ylabel('$\Vert E_k\Vert_2$','interpreter','latex','FontSize',12);
% set(gcf,'paperpositionmode','auto');
% print('-depsc','..\..\FirstEdition\Fig\Time-Error.eps')
% figure(2)
% plot(Etime,y_0(1,Etime+1),'b',LineWidth=1.5);hold on
% plot(Etime,y_1(1,Etime+1),'r',LineWidth=1.5);hold on
% lgd=legend('$Y_k^0$','$Y_k^1$','FontSize',12,'Interpreter','latex');
% xlabel('$k$','interpreter','latex','FontSize',12);
% set(gcf,'paperpositionmode','auto');
% print('-depsc','..\..\FirstEdition\Fig\Time-Output.eps')
% figure(3)
% plot3(E_Plot(1,Dtime+1),E_Plot(2,Dtime+1),E_Plot(3,Dtime+1),LineWidth=1.5)
% xlabel('x','FontSize',12);
% ylabel('y','FontSize',12);
% zlabel('z','FontSize',12);
% set(gcf,'paperpositionmode','auto');
% figure(4)
% plot3(X_Plot(1,Dtime+1),X_Plot(2,Dtime+1),X_Plot(3,Dtime+1),LineWidth=1.5)
% xlabel('x','FontSize',12);
% ylabel('y','FontSize',12);
% zlabel('z','FontSize',12);
% set(gcf,'paperpositionmode','auto');
% figure(3)
% plot3(x0plot(1,Dtime+1),x0plot(2,Dtime+1),x0plot(3,Dtime+1),'r',LineWidth=1.5);hold on
% plot3(x1plot(1,Dtime+1),x1plot(2,Dtime+1),x1plot(3,Dtime+1),'b',LineWidth=1.5);hold on
% plot3(x2plot(1,Dtime+1),x2plot(2,Dtime+1),x2plot(3,Dtime+1),'k',LineWidth=1.5);hold on
% plot3(x3plot(1,Dtime+1),x3plot(2,Dtime+1),x3plot(3,Dtime+1),'g',LineWidth=1.5);hold on
% scatter3(x0plot(1,1),x0plot(2,1),x0plot(3,1),100,'rp','filled');hold on
% scatter3(x1plot(1,1),x1plot(2,1),x1plot(3,1),100,'bp','filled');hold on
% scatter3(x2plot(1,1),x2plot(2,1),x2plot(3,1),100,'kp','filled');hold on
% scatter3(x3plot(1,1),x3plot(2,1),x3plot(3,1),100,'gp','filled');hold on

% for k=4:3:DEnd
%     scatter3(x0plot(1,k),x0plot(2,k),x0plot(3,k),60,'rd','filled');hold on
%     scatter3(x1plot(1,k),x1plot(2,k),x1plot(3,k),60,'bd','filled');hold on
%     scatter3(x2plot(1,k),x2plot(2,k),x2plot(3,k),60,'kd','filled');hold on
%     scatter3(x3plot(1,k),x3plot(2,k),x3plot(3,k),60,'gd','filled');hold on
% end

% scatter3(x0plot(1,Dtime(end)+1),x0plot(2,Dtime(end)+1),x0plot(3,Dtime(end)+1),60,'r^','filled');hold on
% scatter3(x1plot(1,Dtime(end)+1),x1plot(2,Dtime(end)+1),x1plot(3,Dtime(end)+1),60,'b^','filled');hold on
% scatter3(x2plot(1,Dtime(end)+1),x2plot(2,Dtime(end)+1),x2plot(3,Dtime(end)+1),60,'k^','filled');hold on
% scatter3(x3plot(1,Dtime(end)+1),x3plot(2,Dtime(end)+1),x3plot(3,Dtime(end)+1),60,'g^','filled');hold on
% lgd=legend('Evader','Pursuer $1$','Pursuer $2$','Pursuer $3$','FontSize',12,'Interpreter','latex','location','Best');
% text(-5,0,-20,'Start Point', 'fontsize', 12,'Interpreter','latex')
% text(22,-10,-22,'End Point', 'fontsize', 12,'Interpreter','latex')
% xlabel('x','FontSize',12);
% ylabel('y','FontSize',12);
% zlabel('z','FontSize',12);
% set(gcf,'paperpositionmode','auto');
% % h=annotation('textarrow',[0.60 0.72],[0.8 0.75]);
% % set(h, 'string','Motion Direction', 'fontsize', 12,'Interpreter','latex');
% text(1.5,1.8,85,'Motion Direction', 'fontsize', 12,'Interpreter','latex')
% h=annotation('arrow',[0.60 0.72],[0.8 0.75]);
% view(-20, 45);
% print('-depsc','..\..\FirstEdition\Fig\3D-State.eps')
% figure(4)
% values0=spcrv([x0plot(:,1) x0plot(:,Dtime+1) x0plot(:,DEnd+1)],3);
% values1=spcrv([x1plot(:,1) x1plot(:,Dtime+1) x1plot(:,DEnd+1)],3);
% values2=spcrv([x2plot(:,1) x2plot(:,Dtime+1) x2plot(:,DEnd+1)],3);
% values3=spcrv([x3plot(:,1) x3plot(:,Dtime+1) x3plot(:,DEnd+1)],3);
% plot3(values0(1,:),values0(2,:),values0(3,:),'r',LineWidth=1.5);hold on
% plot3(values1(1,:),values1(2,:),values1(3,:),'b',LineWidth=1.5);hold on
% plot3(values2(1,:),values2(2,:),values2(3,:),'k',LineWidth=1.5);hold on
% plot3(values3(1,:),values3(2,:),values3(3,:),'g',LineWidth=1.5);hold on

% figure(4)
% plot(Etime,AreaPlot(Etime+1),'r',LineWidth=1.5);
% xlabel('$k$','interpreter','latex','FontSize',12);
% ylabel('$S_k^a$','interpreter','latex','FontSize',12);
% set(gcf,'paperpositionmode','auto');
% print('-depsc','..\..\FirstEdition\Fig\Time-Area.eps')
% figure(5)
% plot(Etime,log10(1+SquarePlot(Etime+1)),'r',LineWidth=1.5);
% xlabel('$k$','interpreter','latex','FontSize',12);
% ylabel('$X_k^a$','interpreter','latex','FontSize',12);
% set(gcf,'paperpositionmode','auto');
% print('-depsc','..\..\FirstEdition\Fig\Time-Square.eps')
% figure(2)
% curve=plot(Xi_Plot(1,:));
% hold on
% legend(curve,'递减型')
% legend('off'); legend('show');
% plot(Xi_Plot(2,:))