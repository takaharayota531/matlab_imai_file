function [d_h,d_v,f] = read_directivity2

filename1 = 'directivity_h_amp.csv';
filename2 = 'directivity_h_phase.csv';
filename3 = 'directivity_v_amp.csv';
filename4 = 'directivity_v_phase.csv';

M1 = readmatrix(filename1);
M2 = readmatrix(filename2);
M3 = readmatrix(filename3);
M4 = readmatrix(filename4);

f = M1(1,2:end); % 周波数ラベル

dha = M1(2:end,2:end);
dhp = M2(2:end,2:end);
dva = M3(2:end,2:end);
dvp = M4(2:end,2:end);

% 水平方向の指向性
d_sum = sum(dha,2); % それぞれの角度でのゲインを足し合わせる
[M,I] = max(d_sum); % 最もゲインが高い角度を確認
dha = circshift(dha,181-I,1); % 中央(181セル目)が最大になるようにシフト
dhp = circshift(dhp,181-I,1);
dha = dha-dha(180,:);
% dhp = dhp-dhp(180,:);
d_h = 10.^(dha/10).*exp(1i*dhp/180*pi);

% 垂直方向の指向性
d_sum = sum(dva,2); % それぞれの角度でのゲインを足し合わせる
[M,I] = max(d_sum); % 最もゲインが高い角度を確認
dva = circshift(dva,181-I,1); % 中央(181セル目)が最大になるようにシフト
dvp = circshift(dvp,181-I,1);
dva = dva-dva(180,:);
% dvp = dvp-dvp(180,:);
d_v = 10.^(dva/10).*exp(1i*dvp/180*pi);

end

