clear;clc;close all force;

load('result/mine05/1_2%/result7');
history = his;
[Nx,Ny,Nf,N] = size(history);
% model = make_model(r,t);
m = size(model,1);
f_his = zeros(N,1);

% for i = 1:N
%     s = history(:,:,:,i);
%     f_his(i) = calc_f(s,1,model,p);
% end

% figure; plot(alpha_his);
% figure; plot(f_his);
% show_history_all(h_his(:,:,1:2:end))
% show_s(his(:,:,:,1))
% show_s(his(:,:,:,end))

% N = 20;
% df1 = df_his(:,:,:,1,1);
% df2 = df_his(:,:,:,2,1);
% alpha = alpha_his(1);
% s = history(:,:,:,1);
% f_re = zeros(41,1);
% f_st = zeros(41,1);
% f = calc_f(s,l,model,p);
% for i = -N:N
%    f_re(i+21) = calc_f(s+alpha*i*df2,l,model,p);
%    f_st(i+21) = f + (sum(df1.*df2,'all')+sum(df2.*conj(df2),'all'))*i*alpha;
% end
% figure;
% plot((-N:N)*alpha,f_re,(-N:N)*alpha,f_st);

% show_history(h_his);
% show_history_all_2(h_his,1,model);
% show_s(history(:,:,:,1));
% show_s(history(:,:,:,end));
% figure; plot(f_his,'LineWidth',2);set(gca,'FontSize',20,'LineWidth',2);xlim([1 20]);
% figure; plot(log10(alpha_his)); xlabel('step'); ylabel('log_{10}\alpha');set(gca,'FontSize',20);
% make_movie_h(h_his,model);

gap = floor((m+1-2)/2);
h_his = circshift(h_his,[gap gap 0]);
h = h_his(:,:,end);
[M I] = max(h,[],'all','linear');
pos = [mod(I,(Nx)) floor(I/(Nx))];
% display_position(pos,model,Nx);
% show_history_10_scaled(h_his,1,model);
%figure;imagesc(sample);colorbar;colormap(gray);
% plot(squeeze(sum(abs(df_his),[1 2 3])));

%% データを複数ロード
clear;clc;close all force;
dataname = 'mine05';
fontsize = 12;
close all;
rate = 2;
Nx = 50;
Ny = 50;
pos = zeros(Nx,Ny);
land_s = zeros(Nx,Ny);
land_e = zeros(Nx,Ny);
for i = 1:100
    filename = horzcat('result/', dataname, '/2_', num2str(rate), '%/result', num2str(i));
    load(filename);
    land_s = land_s + display_position(h_his(:,:,1),model);
    land_e = land_e + display_position(h_his(:,:,end),model);
%     show_history_10_scaled(h_his,1,model)
end
figure; imagesc(land_s); colormap(gray);
c = colorbar;
c.Label.String = 'Number of Times';
c.Label.FontSize = fontsize;
xlabel('Position $x$','Fontsize',fontsize,'FontName','SansSerif','Interpreter','latex');
ylabel('Position $y$','Fontsize',fontsize,'FontName','SansSerif','Interpreter','latex');
exportgraphics(gcf,'figures/land_s.pdf')
figure; imagesc(land_e); colormap(gray);
c = colorbar;
c.Label.String = 'Number of Times';
c.Label.FontSize = fontsize;
xlabel('Position $x$','Fontsize',fontsize,'FontName','SansSerif','Interpreter','latex');
ylabel('Position $y$','Fontsize',fontsize,'FontName','SansSerif','Interpreter','latex');
exportgraphics(gcf,'figures/land_e.pdf')
%% 関数セクション

function land = display_position(h,model)
[Nx,Ny] = size(h);
[M,I] = max(h,[],'all','linear');
pos = [mod(I-1,Ny)+1 floor(I/Nx)+1];
land = zeros(Nx,Ny);
Nm = size(model,1);
for x = 1:Nm
    for y = 1:Nm
        if model(x,y) == 1
            land(mod(pos(1)+x-2,Nx)+1,mod(pos(2)+y-2,50)+1) = 1;
        end
    end
end
% 地雷の位置を表示
% figure;imagesc(land);colormap(gray);
end

function f = calc_f(s,l,model,p)
% k = calc_k(s,l);
h = calc_h_10_2(s,model);
f = sum(abs(h).^p,'all');
end