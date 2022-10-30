function [d_h,d_v,f] = read_directivity

% 水平方向の指向性
filename = 'directivity_h_near.txt';
A = readmatrix(filename);
f = A(1,2:end); % 周波数ラベル
d = A(2:end,2:end); % ラベル除去
dmax = max(d,[],'all');
d = d-dmax; % 最大値が0になるように調整
d_sum = sum(d,2); % それぞれの角度でのゲインを足し合わせる
[M,I] = max(d_sum); % 最もゲインが高い角度を確認
d = circshift(d,181-I,1); % 中央(181セル目)が最大になるようにシフト
d = d-d(180,:);
d_h = 10.^(d/10);

% 垂直方向の指向性
filename = 'directivity_v_near.txt';
A = readmatrix(filename);
d = A(2:end,2:end); % ラベル除去
dmax = max(d,[],'all');
d = d-dmax; % 最大値が0になるように調整
d_sum = sum(d,2); % それぞれの角度でのゲインを足し合わせる
[M,I] = max(d_sum); % 最もゲインが高い角度を確認
d = circshift(d,181-I,1); % 中央(181セル目)が最大になるようにシフト
d = d-d(180,:);
d_v = 10.^(d/10);
end

