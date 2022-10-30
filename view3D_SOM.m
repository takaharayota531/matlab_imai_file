% xystage使用のデータからデータを吸い込んで複素反射係数を出力
% xystageがゲットしたデータは直線に測定したもの（liner_measure.viを想定）

close all;
clear;
set(0, 'defaultAxesFontName', 'Arial');
set(0, 'defaultTextFontName', 'Arial');
set(0, 'DefaultAxesFontSize', 12);
set(0, 'DefaultTextFontSize', 12);
set(0, 'DefaultAxesLineWidth', 1);
set(0, 'DefaultFigureColor', 'w');

%% パラメータの設定

% 測定パラメーター
START_FREQ = 1; % 測定開始周波数（GHz）
STOP_FREQ = 21; % 測定終了周波数（GHz）
FREQ_POINT = 401; %周波数のポイント数(8GHz除去で100点)
SCALE_X = 60; % XYステージでX方向へ動かした回数
SCALE_Y = SCALE_X;
DX = 0.5; % XYステージで一回あたりにX方向へ動く距離（cm）
rawdata = ''20210727mine'.txt'; % 読み込むテキストファイル名



% 解析パラメーター
CUT_DISTANCE1 = 40; % 解析範囲の下限値（cm）
CUT_DISTANCE2 = 70; % 解析範囲の上限値（cm）
DISP_ABOVE = 40; % 表示範囲の下限値（cm）
DISP_BELOW = 100; % 表示範囲の上限値（cm）
N_IFFT = 2^10; % IFFT数
ITERATION = 5; % 最大値を探す作業を何回繰り返すか
DISP_X = 3; % どの場所のS21を表示するかX軸での位置を指定（cm）
DISP_Y = 58; % どの場所のS21を表示するかY軸での位置を指定（cm）
S = 0.1; % 二項分布の分散
VIEW_DZ = 0.1; % 位相画像を表示する際の一つのピークの幅（cm）
if DISP_X < 1 || DISP_X > SCALE_X % disp_fが測定周波数に入っていない場合は警告
    disp('パラメータ disp_x が正しい範囲に設定されていません')
    return
end
if CUT_DISTANCE1 > CUT_DISTANCE2 % cut_distanceの大小が逆の場合は警告
    disp('パラメータ cut_distance1 と cut_distance2 の大小が逆です')
    return
end


%% rowdataの読み込みと確認

fprintf('Loading txt data \n\n');
rawdata = load(rawdata); % 計測データ読み取り[index, frequency, amplitude, phase, x, y]

c = 1; % for文で回す用の数字
data = zeros(length(rawdata)*((FREQ_POINT-1)/FREQ_POINT),6); % rawdataを入れなおす配列
for n = 1:length(rawdata)
    if rawdata(n,1) ~= 0 % 各測定ポイントにおいて測定バグのポイントを除外
        data(c,:) = rawdata(n,:); % 新しい配列に代入
        c = c+1;
    end
end

S21 = zeros(SCALE_Y,SCALE_X,FREQ_POINT-1); % S21（複素数）を格納する配列
df = (STOP_FREQ-START_FREQ)/(FREQ_POINT-1); % 周波数における測定間隔（GHz）
f = (START_FREQ+df:df:STOP_FREQ)*10^9; % 測定した周波数を分割（Hz）
df = df*10^9; % 測定間隔をHzに直す

for x = 1:SCALE_X % 配列に
    for y = 1:SCALE_Y
        finish_point = (FREQ_POINT-1)*((x-1)*SCALE_Y+y-1); % その座標のデータは何番目から始まるのか
        G = data(finish_point+1:finish_point+FREQ_POINT-1,3); % 振幅を抽出（log形式）
        P = data(finish_point+1:finish_point+FREQ_POINT-1,4)/180*pi; % 位相を抽出
        S21(y,x,:) = 10.^(G/10).*exp(1i*P); % 複素数データに直して格納
    end
end

disp_data = zeros(1,FREQ_POINT-1);
DISP_X = DISP_X/DX;
for k = 1:FREQ_POINT-1
    disp_data(k) = S21(DISP_X,DISP_X,k);
end


figure('Name','ある場所でのS21');subplot(2,1,1);plot(f/10^9,10*log10(abs(disp_data)),'b','linewidth', 2.0);xlim([START_FREQ STOP_FREQ]);
xlabel('Frequency (GHz)');ylabel('Signal power (dB)');set(gca, 'LooseInset', get(gca, 'TightInset'));
subplot(2,1,2);plot(f/10^9,angle(disp_data),'b','linewidth', 2.0);xlim([START_FREQ STOP_FREQ])
xlabel('Frequency (GHz)');ylabel('Phase (rad)');set(gca, 'LooseInset', get(gca, 'TightInset'));


%% 深さ方向へ変換

peak_distance = zeros(SCALE_X, 1); % ピーク距離情報を格納する所
% complex_r = zeros(SCALE_X, 1); % 振幅最大ポイントの複素反射係数を格納

fprintf(strcat(num2str(N_IFFT),' points fourier transfer \n\n'))

onecircle_t = 1/df; % 時間応答での周期
t = 0:onecircle_t/N_IFFT:onecircle_t -onecircle_t/N_IFFT; % 時間応答の周期をN点分割する
c = 299792458; % 光速（m/s）
z = t*c/2; % アンテナからの距離に対応する座標、往復距離が出るから2で割ってアンテナからの距離（m）
dz = z(2)-z(1); % アンテナからの距離配列の間隔（m）

% 40cmから70cmを切り落とす
cut_value1 = round(CUT_DISTANCE1/100/dz); % 切り落とす距離は要素の何番目か
cut_value2 = round(CUT_DISTANCE2/100/dz); % 
cutfilter1 = zeros(1,cut_value1); % 切り落とす部分
cutfilter2 = ones(1,cut_value2-cut_value1);
cutfilter3 = zeros(1,N_IFFT-cut_value2);
filter = horzcat(cutfilter1,cutfilter2,cutfilter3);

twoD_textual = zeros(SCALE_Y,SCALE_X,N_IFFT); % フーリエ変換後の距離を格納する配列
win = chebwin(FREQ_POINT-1);
phase_re = zeros(SCALE_Y,SCALE_X,FREQ_POINT-1);

for k = 1:SCALE_X
    for i = 1:SCALE_Y
        data = zeros(1,FREQ_POINT-1);
        for m = 1:FREQ_POINT-1
            data(m) = S21(i,k,m);
        end
        F = ifft(data,N_IFFT); % S21を逆フーリエ変換
        twoD_textual(i,k,:) = F.*filter; % パルス応答を指定距離で切り取り格納
    end
end


x = DX:DX:DX*SCALE_X; % x軸の設定
y = x;

disp_data = zeros(1,N_IFFT);
for m = 1:N_IFFT
    disp_data(m) = twoD_textual(DISP_X,DISP_X,m);
end

figure('Name','パルス応答（振幅）');plot(z*100,abs(disp_data),'b','linewidth', 2.0);set(gca, 'LooseInset', get(gca, 'TightInset'));
xlabel('Distance from antenna (cm)');ylabel('Signal power (arb)');xlim([CUT_DISTANCE1 CUT_DISTANCE2]);
figure('Name','パルス応答（位相）');plot(z*100,angle(disp_data),'b','linewidth', 2.0);set(gca, 'LooseInset', get(gca, 'TightInset'));
xlabel('Distance from antenna (cm)');ylabel('Phase (rad)');xlim([CUT_DISTANCE1 CUT_DISTANCE2]);

%% 位相復元法


fprintf('Phase Retrieving ... \n\n')
peak_point = zeros(SCALE_Y,SCALE_X,N_IFFT);
peak_amplitude = zeros(SCALE_Y,SCALE_X,N_IFFT);
peak_phase = zeros(SCALE_Y,SCALE_X,N_IFFT);
peak_S21 = zeros(SCALE_Y,SCALE_X,N_IFFT,FREQ_POINT-1);
threshold = max(max(max(abs(twoD_textual))))*0.1;
VIEW_DZ = round(VIEW_DZ/100/dz/2);

for k = 1:SCALE_X
    for h = 1:SCALE_Y
        F = zeros(1,N_IFFT);
        for m = 1:N_IFFT
            F(m) = twoD_textual(h,k,m);
        end

        for i = 1:ITERATION
            M = abs(F); % フーリエ変換後の振幅情報
            [peak_val, peak_pixel] = max(M); % ピークが一番立つ場所の情報
            if peak_val > threshold
                peak_point(h,k,peak_pixel) = 1;
                peak_amplitude(h,k,peak_pixel) = peak_val;
                win_fun = gaussian(z,peak_pixel*dz,S); % ガウスウィンドウ作成
                F_gau = F.*win_fun; % dataにガウスフィルターを適用
                F_shift = circshift(F_gau,-peak_pixel); % t=0(z=0)にシフト
                complex_r = fft(F_shift,N_IFFT); % 周波数領域に変換
                complex_r = complex_r(1:(FREQ_POINT-1));
                peak_S21(h,k,peak_pixel,:) = complex_r; 
                peak_phase(h,k,peak_pixel) = angle(mean(complex_r));
                F = F-F_gau;
            end
        end
    end
end

%% 位相復元後の位相の様子

cdata = whiter(peak_phase, 'hsv', -pi, pi, peak_point);

figure('Name','位相復元後の位相');
for k = 1:SCALE_X
    for h = 1:SCALE_Y
        for m = 1:N_IFFT
            if peak_point(h,k,m) == 1
                x_init = (k-1)*DX;
                y_init = (h-1)*DX;
                z_init = m*dz*100;
                vert = [x_init y_init z_init;x_init+DX y_init z_init;x_init+DX y_init+DX z_init;x_init y_init+DX z_init;...
                    x_init y_init z_init+DX;x_init+DX y_init z_init+DX;x_init+DX y_init+DX z_init+DX;x_init y_init+DX z_init+DX];
                fac = [1 2 6 5;2 3 7 6;3 4 8 7;4 1 5 8;1 2 3 4;5 6 7 8];
                color = zeros(1,3);
                color(1) = cdata(h,k,m,1);
                color(2) = cdata(h,k,m,2);
                color(3) = cdata(h,k,m,3);
                color = repmat(color,8,1);
                patch('Vertices',vert,'Faces',fac,'FaceVertexCData',color,'FaceColor','flat')
                hold on
            end
        end
    end
end
zlabel('Distance from antenna (cm)');ylabel('Position Y (cm)');xlabel('Position X (cm)');zlim([CUT_DISTANCE1 CUT_DISTANCE2]);view(3)
colorbar;colormap hsv;set(gca,'ZDir','reverse');set(gca,'YDir','reverse');caxis([-pi pi])
hold off

%% SOMの学習

peak_S21 = peak_S21/max(max(max(max(abs(peak_S21)))));
alpha = 0.2; beta = alpha/100; %α,βの値
loop = 100; % 参照ベクトルの更新回数

w_points = 8; % 参照ベクトルの数
w_scale = max(max(max(max(abs(peak_S21))))); % 参照ベクトルの最大値
k_dim = FREQ_POINT-1; % 参照ベクトルの次元、この場合は周波数ポイント
w_in = w_init(w_points ,w_scale ,k_dim); % 参照ベクトルの生成と初期化

w = w_in; % 初期化参照ベクトルの代入
kxy = size(peak_S21(:,:,1)); % ベクトルの
c = zeros(kxy(1),kxy(2));
mov(1:loop) = struct('cdata', [], 'colormap', []);

tic % 学習にかかる時間を表示
for t = 1:loop
%     alpha = alpha*(loop-t)/loop;
%     beta = beta*(loop-t)/loop;
    
    % 学習を行う
    for som_x = 1:kxy(2)
        for som_y = 1:kxy(1)
            k_temp(:,1) = peak_S21(som_y,som_x,:);
            if k_temp ~= zeros(FREQ_POINT-1,1)
                min = sum(abs(k_temp-w(:,1)));
%                 min = norm(k_temp-w(:,1));
                c(som_y,som_x) = 1;
                %勝者クラスを探す
                for n = 2:w_points
                    temp = sum(abs(k_temp-w(:,n)));
%                     temp = norm(k_temp-w(:,n));
                    if min > temp
                        min = temp;
                        c(som_y,som_x) = n;
                    end
                end
                

                w(:,c(som_y,som_x)) = w(:,c(som_y,som_x)) + alpha * (k_temp(:,1) - w(:,c(som_y,som_x))); % αによる更新
            
                switch c(som_y,som_x)  %βによる更新
                    case w_points  %クラスw_points(端)のとなりのクラスは'1'と'(w_points-1)'
                        w(:,(c(som_y,som_x) - 1)) = w(:,(c(som_y,som_x) - 1)) + beta * (k_temp(:,1) - w(:,(c(som_y,som_x) - 1)));
                        w(:,1) = w(:,1) + beta *  (k_temp(:,1) - w(:,1));
                    
                    case 1  %クラス1(端)のとなりのクラスは'2'と'w_points'
                        w(:,(c(som_y,som_x) + 1)) = w(:,(c(som_y,som_x) + 1)) + beta * (k_temp(:,1) - w(:,(c(som_y,som_x) + 1)));
                        w(:,w_points) = w(:,w_points) + beta * (k_temp(:,1) - w(:,w_points));
                    
                    otherwise
                        w(:,(c(som_y,som_x) - 1)) = w(:,(c(som_y,som_x) - 1)) + beta * (k_temp(:,1) - w(:,(c(som_y,som_x) - 1)));
                        w(:,(c(som_y,som_x) + 1)) = w(:,(c(som_y,som_x) + 1)) + beta * (k_temp(:,1) - w(:,(c(som_y,som_x) + 1)));
                end
            end
        end
    end
    
    disp(strcat(num2str(round(t/loop*100)),'% of learning was finished'))
    som_cdata = whiter(c, hsv(w_points), 1, w_points, peak_point);
    
    figure(100);imagesc(x,z*100,som_cdata);colormap(hsv(w_points));colorbar
    xlabel('Position X (cm)');ylabel('Distance from antenna (cm)');ylim([CUT_DISTANCE1 CUT_DISTANCE2]);caxis([0 w_points])
    mov(t) = getframe(100);
end
toc
close 100

figure('Name','SOMでのピーク分類結果');imagesc(x,z*100,som_cdata);colormap(hsv(w_points));colorbar
xlabel('Position X (cm)');ylabel('Distance from antenna (cm)');ylim([CUT_DISTANCE1 CUT_DISTANCE2]);caxis([0 w_points])


%% ガウス分布を出力する関数

function f = gaussian(x,m,s)
f = exp(-(x-m).^2/2/s^2);
end

%% 参照ベクトルを作成する関数

function w = w_init(w_points ,w_scale ,k_dim)
w_A = w_scale*rand(k_dim, w_points);
w_P = 2*pi*rand(k_dim, w_points);
w = w_A.*exp(1i*w_P);
end

%% 無関係エリアを白抜きする関数

function c_out = whiter(input_data, color_type, min, max, check_matrix)
cm = colormap(color_type);
cdata = interp1(linspace(min,max,length(cm)),cm,input_data);
SCALE_X = length(input_data(1,:,1));
SCALE_Y = length(input_data(:,1,1));
SCALE_Z = length(input_data(1,1,:));

for k = 1:SCALE_X
    for i = 1:SCALE_Y
        for m = 1:SCALE_Z
            if check_matrix(i,k,m) == 0
                cdata(i,k,m,:) = [1,1,1];
            end
        end
    end
end

c_out = cdata;
end
