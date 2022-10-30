clear;clc;close all force;
set(0, 'defaultAxesFontName', 'Arial');
set(0, 'defaultTextFontName', 'Arial');
set(0, 'DefaultAxesFontSize', 12);
set(0, 'DefaultTextFontSize', 12);
set(0, 'DefaultAxesLineWidth', 1);
set(0, 'DefaultFigureColor', 'w');

%% パラメータ設定
dataname = {'metal_100mm','metal_200mm','metal_300mm'};
datanameH = 'hosei(1-21GHz401points)';

START_FREQ = 1.1e9; % 開始周波数(Hz)最初の点はうまく取れていないので２点目から
STOP_FREQ = 21.0e9; % 終了周波数(Hz)
FREQ_POINT = 200; % 周波数計測点数
DX = 5e-3; % 計測間隔(m)
CUT_DISTANCE1 = 0.4; % 解析範囲の下限値（m）
CUT_DISTANCE2 = 0.7; % 解析範囲の上限値（m）
N_PR = 2^4; % 位相復元する点数の目安

N_IFFT = 2^10; % 逆フーリエ変換点数
S = 0.05; % 二項分布の分散
C = 299792458; % 光速(m/s)
%% 計測データのロード

s_temp = {data_load_XY(dataname{1},datanameH),data_load_XY(dataname{2},datanameH),data_load_XY(dataname{3},datanameH)}; % txtデータのロード

%% 深さ方向へ変換
disp('Transforming to time domain')
df = (STOP_FREQ-START_FREQ)/(FREQ_POINT-1); % 周波数ステップ幅
N_head = floor(START_FREQ/df); % START_FREQまでの埋めるべき周波数点数
s = zeros(3,N_IFFT); % 埋める周波数を含めた周波数応答格納配列
for i = 1:3
    s(i,N_head+1:N_head+FREQ_POINT) = s_temp{i}(:,:,2:2:400);
    % s(:,:,N_head+1:N_head+FREQ_POINT) = exp(1i*angle(s_temp(:,:,2:2:200))); % 振幅を1に統一して相対的な低周波数の影響を小さくする。
end

t_cycle = 1/df;
t = 0:t_cycle/N_IFFT:t_cycle-t_cycle/N_IFFT;
l = t*C;
z = sqrt(l.^2-0.05^2)/2;
dz = z(2)-z(1);

% 各周波数深さ毎に減衰分の補正を行う

f = START_FREQ-df*N_head:df:START_FREQ-df*N_head+df*(N_IFFT-1);
s_v = zeros(3,N_IFFT);
s_v = squeeze(correct_attenuation(reshape(s,[3 1 N_IFFT]),f,l)); % 周波数と距離による減衰差を考慮
% s_v = ifft(s,N_IFFT,2); % 深さ方向への変換(逆フーリエ変換）

index = find(z>CUT_DISTANCE1 & z<CUT_DISTANCE2); % 表示範囲内のピクセルのインデックス

%% プロット
figure;
plot(l,abs(s_v));
legend('100mm','200mm','300mm');
xlabel('distance[m]');
ylabel('amplitude');

