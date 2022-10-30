clear; clc; close all;

% dataload
filename = 'directivity_h_near.txt'; % アンテナ間約0.7m
A = readmatrix(filename);
filename = 'directivity_h.txt'; % アンテナ間約1.7m
B = readmatrix(filename);
filename = 'directivity_v_near.txt'; % アンテナ間約0.7m
C = readmatrix(filename);
filename = 'directivity_v.txt'; % アンテナ間約1.7m
D = readmatrix(filename);

nu = physconst('Lightspeed');
%%
d = A(2:end,2:2:end); % ラベル除去
theta = A(2:end,1)/360*2*pi; % 角度ラベルをラジアンに変換
f = A(1,2:2:end);
d_sum = sum(d,2); % それぞれの角度でのゲインを足し合わせる
[M,I] = max(d_sum); % 最もゲインが高い角度を確認
d = circshift(d,181-I,1); % 中央(181セル目)が最大になるようにシフト

d2 = B(2:end,2:2:end); % ラベル除去
d2_sum = sum(d2,2); % それぞれの角度でのゲインを足し合わせる
[M,I] = max(d2_sum); % 最もゲインが高い角度を確認
d2 = circshift(d2,181-I,1); % 中央(181セル目)が最大になるようにシフト

d_f1 = d(180,:); % 周波数方向の変化を参照
d_f2 = d2(180,:); % 周波数方向の変化を参照
d_t1 = 20*log10(nu/pi/4/0.6)-20*log10(f);
d_t2 = 20*log10(nu/pi/4/1.7)-20*log10(f);
dif = mean(d_f1-d_f2);
figure; plot(f,d_f1,f,d_f2);
legend('D=0.6m','D=1.7m');
xlabel('frequency[Hz]')
ylabel('amplitude[dB]');
figure; plot(f,d_f1-d_t1,f,d_f2-d_t2);
legend('D=0.6m','D=1.7m');
xlabel('frequency[Hz]')
ylabel('amplitude[dB]');

figure; plot(f,d_t1,f,d_t2);
legend('D=0.6m','D=1.7m');
xlabel('frequency[Hz]')
ylabel('amplitude[dB]');
%% 指向性を表示
d = B(2:end,2:2:end); % ラベル除去
theta = B(2:end,1)/360*2*pi; % 角度ラベルをラジアンに変換
f = B(1,2:2:end);
d_sum = sum(d,2); % それぞれの角度でのゲインを足し合わせる
[M,I] = max(d_sum); % 最もゲインが高い角度を確認
d = circshift(d,181-I,1); % 中央(181セル目)が最大になるようにシフト
rho = d(:,1); % 周波数を1つ選択
plot(theta,rho);
xlabel('direction[rad]');
ylabel('amplitude[dB]');
xlim([0 2*pi]);
% polarplot(theta,rho);
show_directivity(d);

%% 位相含めて計測した結果を読み込み
clc; clear; close all;

filename1 = 'directivity_h_amp.csv';
filename2 = 'directivity_h_phase.csv';
filename3 = 'directivity_v_amp.csv';
filename4 = 'directivity_v_phase.csv';

M1 = readmatrix(filename1);
M2 = readmatrix(filename2);
M3 = readmatrix(filename3);
M4 = readmatrix(filename4);

dha = M1(2:end,2:end);
dhp = M2(2:end,2:end);
dva = M3(2:end,2:end);
dvp = M4(2:end,2:end);
dhp = unrap(dhp);
show_directivity(dhp);

function d = unrap(d)
N = size(d,1);
for i = 1:N-1
    index1 = (d(i,:)-d(i+1,:))>180;
    index2 = (d(i,:)-d(i+1,:))<-180;
    d(i+1:end,:) = d(i+1:end,:)+index1*360-index2*360;
end
end