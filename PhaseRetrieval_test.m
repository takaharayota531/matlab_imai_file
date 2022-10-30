clear;clc;close all force;
set(0, 'defaultAxesFontName', 'Arial');
set(0, 'defaultTextFontName', 'Arial');
set(0, 'DefaultAxesFontSize', 12);
set(0, 'DefaultTextFontSize', 12);
set(0, 'DefaultAxesLineWidth', 1);
set(0, 'DefaultFigureColor', 'w');

%% パラメータ設定
dataname = '20211115_1cm_30cm';
datanameH = 'hosei(1-21GHz401points)';

START_FREQ = 1.1e9; % 開始周波数(Hz)最初の点はうまく取れていないので２点目から
STOP_FREQ = 21.0e9; % 終了周波数(Hz)
FREQ_POINT = 200; % 周波数計測点数
X_POINT = 60; % X方向計測点数
Y_POINT = 60; % Y方向計測点数
DX = 5e-3; % 計測間隔(m)
CUT_DISTANCE1 = 0.4; % 解析範囲の下限値（m）
CUT_DISTANCE2 = 1.5; % 解析範囲の上限値（m）
N_PR = 2^4; % 位相復元する点数の目安

% ORIGIN = 0.3375; % 位相原点の位置(m)

N_IFFT = 2^10; % 逆フーリエ変換点数
S = 0.02; % 二項分布の分散
C = 299792458; % 光速(m/s)
%% データロード
[s_temp,f] = data_load_XY_raw('20220126_yellow_3cm'); % txtデータのロード
f = f*1e9;

index = 2:2:200; % select frequency
s_temp = s_temp(:,:,index);
f = f(index);

START_FREQ = f(1); % 開始周波数(Hz)最初の点はうまく取れていないので２点目から
STOP_FREQ = f(end); % 終了周波数(Hz)
[X_POINT,Y_POINT,FREQ_POINT] = size(s_temp); % X,Y方向,周波数方向計測点数
%% 深さ方向へ変換
disp('Transforming to time domain')
df = f(2)-f(1); % 周波数ステップ幅
N_head = floor(START_FREQ/df); % START_FREQまでの埋めるべき周波数点数
s = zeros(X_POINT,Y_POINT,N_IFFT); % 埋める周波数を含めた周波数応答格納配列
s(:,:,N_head+1:N_head+FREQ_POINT) = s_temp(:,:,:);
% s(:,:,N_head+1:N_head+FREQ_POINT) = exp(1i*angle(s_temp(:,:,2:2:200))); % 振幅を1に統一して相対的な低周波数の影響を小さくする。

t_cycle = 1/df;
t = 0:t_cycle/N_IFFT:t_cycle-t_cycle/N_IFFT;
l = t*C;
z = sqrt(l.^2-0.04^2)/2; % 深さを軸にする
% z = l; % 深さではなく経路の長さを軸にする
dz = z(2)-z(1);

% 各周波数深さ毎に減衰分の補正を行う

f = START_FREQ-df*N_head:df:START_FREQ-df*N_head+df*(N_IFFT-1);

% s_v = correct_attenuation(s,f,z); % 周波数と距離による減衰差を考慮
s_v = ifft(s,N_IFFT,3); % 深さ方向への変換(逆フーリエ変換）

x = (0:X_POINT-1)*DX;
y = (0:Y_POINT-1)*DX;

index = find(z>CUT_DISTANCE1 & z<CUT_DISTANCE2); % 表示範囲内のピクセルのインデックス
% show_rawdata(s(:,:,N_head+1:N_head+FREQ_POINT)); % 全表示
%% 図作成

% 全深さ表示
% show_volume(abs(s_v),x,y,z,jet,1);
% show_volume(angle(s_v),x,y,z,hsv,1);

% 指定深さ表示
show_volume(abs(s_v(:,:,index)),x,y,z(index),jet,2);
show_volume(angle(s_v(:,:,index)),x,y,z(index),hsv,2);

% figure; imagesc(squeeze(abs(s_v(20,:,index)))','y',z(index),'x',y);
% xlabel('y[m]'); ylabel('z(depth)[m]'); colormap(jet); c=colorbar; c.Label.String='Amplitiude';
% figure; imagesc(squeeze(angle(s_v(20,:,index)))','y',z(index),'x',y);
% xlabel('y[m]'); ylabel('z(depth)[m]'); colormap(hsv); c=colorbar; c.Label.String='Phase[rad]';

% show_volume(abs(s_v(:,:,index)),x,y,z(index),jet);

% slice(abs(s_v),30,30,500);

% 一部座標のみ表示
% f_index = find(f>=START_FREQ & f<=STOP_FREQ);
% S1 = squeeze(s(10,10,f_index));
% show_frequencial(S1,f(f_index));
% S2 = squeeze(s_v(10,10,:));
% S2 = squeeze(gaussian2(z,206,0.05)...
% + 0.3*gaussian2(z,190,0.1)...
%     + 0.5*gaussian(z,210,0.7)...
%     +0.1*gaussian(z,600,1));
% show_timal(S2,t);

% m = 1.2*max(S2);
% win1 = m*squeeze(gaussian2(z,100,0.1));
% win2 = m*squeeze(gaussian2(z,200,0.1));
% win3 = m*squeeze(gaussian2(z,300,0.1));
% figure;plot(z,abs(S2),z,win1,'red',z,win2,'red',z,win3,'red');

% win1 = squeeze(gaussian2(z,206,0.1));
% figure('Position', [200, 200, 800, 500]);plot(z,S2,z,m*win1,'red');
% xlabel('Time[s]','FontName','SansSerif','Interpreter','latex');
% ylabel('Amplitude','FontName','SansSerif','Interpreter','latex');

% figure('Position', [200, 200, 800, 500]);plot(z,S2.*win1,z,m*win1,'red');
% xlabel('Time[s]','FontName','SansSerif','Interpreter','latex');
% ylabel('Amplitude','FontName','SansSerif','Interpreter','latex');
% 
% win2 = squeeze(gaussian(z,206,0.1));
% figure('Position', [200, 200, 800, 500]);plot(z,circshift(S2.*win2,-206,1),z,circshift(m*win2,-206,1),'red');
% xlabel('Time[s]','FontName','SansSerif','Interpreter','latex');
% ylabel('Amplitude','FontName','SansSerif','Interpreter','latex');
% 
% figure('Position', [200, 200, 800, 500]);plot(z,win1,z,win2,'red');
%% 位相復元法
disp('Phase retrieving');

% for zo = 1:size(z,2)
%     if z(zo) > ORIGIN
%         break;
%     end
% end

% s_v = exp(1i*angle(s_v));

N = size(index,2); % 表示範囲内に含まれる深さ方向の点数
D_PR = ceil(N/N_PR); % 深さ方向の位相復元点の間隔
N_PR_use = floor(N/D_PR); % 位相復元する点数
index_pr = find(f>=8e9-1 & f<=12e9+1); % 移送復元する周波数の範囲
PR_POINT = size(index_pr,2);
S21 = zeros(X_POINT,Y_POINT,N_PR_use,PR_POINT);
i = 0;

zo = 0;

dp = reshape(2*pi*dz/C*(START_FREQ:df:STOP_FREQ+1),[1,1,FREQ_POINT]); % １ピクセルあたりの各周波数での位相回転
%     fig1 = figure;
%     fig2 = figure;
for iz = index(1):D_PR:index(end)
    i = i+1;
    win_fun = gaussian(z,iz,S); % ガウスウィンドウ作成
%     plot(squeeze(win_fun));
    F_gau = s_v.*complex(win_fun); % dataにガウスフィルターを適用
    F_shift = circshift(F_gau,-iz+zo,3); % t=0(z=0)にシフト
%     F_shift = F_gau;
    
%     plot(abs(squeeze(F_shift(1,1,:))));
%     figure(fig1);plot(squeeze(abs(F_shift(1,1,:))));
%     figure(fig2);plot(squeeze(angle(F_shift(1,1,:))));
    complex_r = fft(F_shift,N_IFFT,3); % 周波数領域に変換
%     complex_r = complex_r(:,:,find(f>=START_FREQ-1 & f<=STOP_FREQ+1)); % 計測した周波数のみを取り出す。
    complex_r = complex_r(:,:,index_pr);
%     complex_r = complex_r.*exp(-1i*dp*2*(iz-index(1))); %距離，周波数ごとの位相補正
    S21(:,:,i,:) = reshape(complex_r,X_POINT,Y_POINT,1,[]);
end
z_r = index(1):D_PR:index(end);
K = S21;
K = S21(:,:,:,1:PR_POINT-1).*conj(S21(:,:,:,2:PR_POINT)); % 周波数方向の自己相関を特徴量ベクトルとする
clear F_gau F_shift complex_r;
%% 復元した位相の様子
show_retrieved(K);

% f_index = find(f>=START_FREQ & f<=STOP_FREQ);
% S1 = squeeze(K(10,10,10,:));
% show_frequencial(S1,f(f_index));

% show_4D(angle(S21),x,y,z(index(1):D_PR:index(end)),f,hsv,3);
% show_4D(abs(S21),x,y,z(index(1):D_PR:index(end)),f,jet,2);

% show_all_slices(angle(S21(:,:,:,1)),x,y,z(index(1):D_PR:index(end)),hsv);
% show_all_slices(angle(S21(:,:,:,41)),x,y,z(index(1):D_PR:index(end)),hsv);
% show_all_slices(angle(S21(:,:,:,81)),x,y,z(index(1):D_PR:index(end)),hsv);
% show_all_slices(angle(S21(:,:,:,121)),x,y,z(index(1):D_PR:index(end)),hsv);
% show_all_slices(angle(S21(:,:,:,161)),x,y,z(index(1):D_PR:index(end)),hsv);
% show_all_slices(angle(S21(:,:,:,200)),x,y,z(index(1):D_PR:index(end)),hsv);
% show_all_slices(abs(S21(:,:,:,1)),x,y,z(index(1):D_PR:index(end)),jet);
% show_all_slices(abs(S21(:,:,:,41)),x,y,z(index(1):D_PR:index(end)),jet);
% show_all_slices(abs(S21(:,:,:,81)),x,y,z(index(1):D_PR:index(end)),jet);
% show_all_slices(abs(S21(:,:,:,121)),x,y,z(index(1):D_PR:index(end)),jet);
% show_all_slices(abs(S21(:,:,:,161)),x,y,z(index(1):D_PR:index(end)),jet);
% show_all_slices(abs(S21(:,:,:,200)),x,y,z(index(1):D_PR:index(end)),jet);

% show_all_depth(angle(squeeze(K(:,:,:,1))),hsv);
% v = squeeze(angle(K(:,:,:,1)));
% fig = figure;
% ax = axes;
% [X,Y,Z] = meshgrid(x,y,z(z_r));
% h = slice(ax,X,Y,Z,v,[],[],z(z_r));
% caxis([-pi pi]);
% ax.XLim = [min(x) max(x)];
% ax.YLim = [min(y) max(y)];
% ax.ZLim = [min(z(z_r)) max(z(z_r))];
% ax.ZDir = 'reverse';
% set(h,'edgecolor','none');
% colormap(hsv);
% xlabel('$x$','FontName','SansSerif','Interpreter','latex');
% ylabel('$y$','FontName','SansSerif','Interpreter','latex');
% zlabel('$z$','FontName','SansSerif','Interpreter','latex');
% c = colorbar;
% c.Label.String = 'phase(rad)';
%% ３次元でのhの計算
dm = 1;
r = 10;
d = 5;
model = make_model(r,d);
h = calc_h_3D(S21,model,dm);
%%
R = r+d; % modelの半径
% show_volume(abs(h(R+1:end-R,R+1:end-R,:)),x(R+1:end-R),y(R+1:end-R),z(z_r(1:end-dm+1)),jet,3); % モデルの半径分端をカットして表示
% show_all_depth(h,jet);
show_all_depth(h(R+1:end-R,R+1:end-R,:),jet(4096));
%% SOMの学習

disp('SOM studying');
alpha = 0.8; beta = alpha/5; %α,βの値
loop = 50; % 参照ベクトルの更新回数

w_points = 8; % 参照ベクトルの数

[w,c] = SOM_batch(K,w_points,loop,alpha,beta);
% [w,c] = SOM_batch_2D(K,w_points,loop,alpha,beta);
%%
% show_all_class(c,w_points);
show_all_depth(c,hsv(8));
% show_all_slices(c,x,y,z(z_r),hsv(8));
% fig = figure;
% ax = axes;
% [X,Y,Z] = meshgrid(x,y,z(z_r));
% h = slice(ax,X,Y,Z,c,[],[],z(z_r));
% caxis([min(c,[],'all') max(c,[],'all')]);
% ax.XLim = [min(x) max(x)];
% ax.YLim = [min(y) max(y)];
% ax.ZLim = [min(z(z_r)) max(z(z_r))];
% ax.ZDir = 'reverse';
% set(h,'edgecolor','none');
% colormap(hsv(8));
% xlabel('$x$','FontName','SansSerif','Interpreter','latex');
% ylabel('$y$','FontName','SansSerif','Interpreter','latex');
% zlabel('$z$','FontName','SansSerif','Interpreter','latex');
% c = colorbar;
% c.Label.String = 'class';

%%
%figure('Name','SOMでのピーク分類結果');imagesc(x,z*100,som_cdata);colormap(hsv(w_points));colorbar
%xlabel('Position X (cm)');ylabel('Distance from antenna (cm)');ylim([CUT_DISTANCE1 CUT_DISTANCE2]);caxis([0 w_points])

%% ガウス分布を出力する関数

function f = gaussian(x,i,s)
f = exp(-x.^2/2/s^2); % 片側ガウス分布
n = size(x,2);
f = reshape(f,[1,1,n]); 
f = circshift(f,i,3); % 取り出す位置までシフト
end

function f = gaussian2(x,i,s)
f = exp(-(x-x(i)).^2/2/s^2); % 片側ガウス分布
n = size(x,2);
f = reshape(f,[1,1,n]); 
end

%% ３次元キューブプロット※重いので注意
function cube(v,color,DX,DY,DZ)
figure;
[Nx,Ny,Nz] = size(v);
for x = 1:Nx
    for y = 1:Ny
        for z = 1:Nz
            if v(x,y,z) == 1 % 配列の要素が１の時にキューブを描画
                x_init = (x-1)*DX;
                y_init = (y-1)*DY;
                z_init = (z-1)*DZ;
                vert = [x_init y_init z_init;x_init+DX y_init z_init;x_init+DX y_init+DY z_init;x_init y_init+DY z_init;...
                    x_init y_init z_init+DZ;x_init+DX y_init z_init+DZ;x_init+DX y_init+DY z_init+DZ;x_init y_init+DY z_init+DZ];
                fac = [1 2 6 5;2 3 7 6;3 4 8 7;4 1 5 8;1 2 3 4;5 6 7 8];
                patch('Vertices',vert,'Faces',fac,'FaceVertexCData',color,'FaceColor','flat')
                hold on
            end
        end
    end
end

zlabel('Distance from antenna (m)');ylabel('Position Y (m)');xlabel('Position X (m)');
xlim([0 Nx*DX]);ylim([0 Ny*DY]);zlim([0 Nz*DZ]);view(3)
ax = gca;ax.ZDir = 'reverse';
hold off
end

function show_rawdata(S) % 生データ表示
[Nx,Ny,Nf] = size(S);
S = reshape(S,[Nx*Ny, Nf]).';

figure('Position',[0 540 1920 470]);
imagesc(abs(S));
c1 = colorbar;colormap(jet);
c1.Label.String = 'Amplitude';
xlabel('Position $(1,1,1),(2,1,1),\cdots$','FontName','SansSerif','Interpreter','latex');
ylabel('Frequency','FontName','SansSerif','Interpreter','latex');

figure('Position',[0 0 1920 470]);
imagesc(angle(S));
c2 = colorbar;colormap(hsv);
c2.Label.String = 'Phase[rad]';
xlabel('Position $(x,y)=(1,1),(2,1),\cdots$','FontName','SansSerif','Interpreter','latex');
ylabel('Frequency','FontName','SansSerif','Interpreter','latex');
end
