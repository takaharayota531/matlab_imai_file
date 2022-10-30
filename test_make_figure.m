clc; clear; close all force;

%データの読み込み
dataname = '20211008_big';
dataHname = 'hosei(1-21GHz401points)';
START_FREQ = 1.05e9; % 開始周波数(Hz)最初の点はうまく取れていないので２点目から
STOP_FREQ = 21.0e9; % 終了周波数(Hz)
FREQ_POINT = 400; % 周波数計測点数
s = data_load_XY(dataname,dataHname);
[Nx,Ny,Nf] = size(s);

fontsize = 24;

%% figure of phase retrieval
N = 1024;
Fint = (STOP_FREQ-START_FREQ)/(FREQ_POINT-1);
f = START_FREQ:Fint:STOP_FREQ;
T = 1/Fint;
Tint = T/N;
t = 0:Tint:T-Tint;

disp('Transforming to time domain')
df = (STOP_FREQ-START_FREQ)/(FREQ_POINT-1); % 周波数ステップ幅
N_head = floor(START_FREQ/df); % START_FREQまでの埋めるべき周波数点数
s = zeros(X_POINT,Y_POINT,N_IFFT); % 埋める周波数を含めた周波数応答格納配列
s(:,:,N_head+1:N_head+FREQ_POINT) = s_temp(:,:,2:2:400);
% s(:,:,N_head+1:N_head+FREQ_POINT) = exp(1i*angle(s_temp(:,:,2:2:200))); % 振幅を1に統一して相対的な低周波数の影響を小さくする。

l = t*C;
% z = sqrt(l.^2-0.05^2)/2; % 深さを軸にする
z = l; % 深さではなく経路の長さを軸にする
dz = z(2)-z(1);

% 各周波数深さ毎に減衰分の補正を行う

fa = START_FREQ-df*N_head:df:START_FREQ-df*N_head+df*(N_IFFT-1);

s_v = correct_attenuation(s,f,z); % 周波数と距離による減衰差を考慮
s_v = ifft(s,N_IFFT,3); % 深さ方向への変換(逆フーリエ変換）

S1 = squeeze(s(10,10,:));
show_frequencial(S1,f);

S2 = squeeze(s_v(1,1,:));
show_timal(S2,t);

%% fullmodel
r = 8;
t = 0;
model = make_model(r,t);
m = size(model,1);

filter = -ones(Nx,Ny);
x = 1:m;
y = 1:m;
filter(x,y) = filter(x,y) + 2*model;

figure;
im = imagesc(filter);
im.Parent.FontSize = fontsize;
colormap(gray);
colorbar('Fontsize',fontsize);
xlabel('Position $x$','Fontsize',fontsize,'FontName','SansSerif','Interpreter','latex');
ylabel('Position $y$','Fontsize',fontsize,'FontName','SansSerif','Interpreter','latex');

%% smallmodel
r = 8;
t = 3;
model = make_model(r,t);
m = size(model,1);
fontsize = 12;

filter = zeros(Nx,Ny);
x = 1:m;
y = 1:m;
xm = 28;
ym = 28;
% x = xm:xm+m-1;
% y = ym:ym+m-1;
filter(x,y) = filter(x,y) + model;

figure;
im = imagesc(filter);
im.Parent.FontSize = fontsize;
colormap(gray);
colorbar('Fontsize',fontsize);
xlabel('Position $x$','Fontsize',fontsize,'FontName','SansSerif','Interpreter','latex');
ylabel('Position $y$','Fontsize',fontsize,'FontName','SansSerif','Interpreter','latex');
