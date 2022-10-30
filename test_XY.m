clear;clc;close all force;

% dataname = 'mine05';
dataname = '20210707mine';
% dataHname = 'hosei05';
dataHname = '20210707hosei';

s = data_load_XY(dataname,dataHname);
s = s(:,:,[1 10:10:100]);

p = 0.1;
%% データの取り出しと補間
% 平面座標に関してランダムにサンプルをとりその座標のすべての周波数のデータを使う。
[s_sample,sample,sample_list] = data_sample(s,2);
s_use = data_fill(s_sample,sample_list);

%% データの取り出しと補間2
% 周波数方向に対してもランダムにサンプルをとる。
[s_use,s_sample,sample,sample_list] = data_sample_all(s,1);

%% sから直接hを計算
r = 8;
t = 3;
model = make_model(r,t);
h = calc_h(s,model);
show_h(h);
exportgraphics(gcf,'figures/h_small.pdf')
put_model(h,model);
exportgraphics(gcf,'figures/hp_small.pdf')
%% 3次元面でhを表現
m = size(model,1);
l = 1;
gap = floor((m+l-2)/2);
h = circshift(h,[gap gap]);
figure;surf(1:50,1:50,h);

%% 最適化

model = make_model(7,3);
[s_result,his,h_his,alpha_his,df_his] = gradient_descent(s_use,sample,model,p);
show_history_10_scaled(h_his,1,model);

%% ランダムサンプリングを何回か繰り返し，サンプル座標による最適化結果の変化を調べる
clear;clc;close all force;

dataname = 'mine05';
dataHname = 'hosei05';

s = data_load_XY(dataname,dataHname);
% show_s(s);

p = 0.1;
n = 10; % 繰り返し回数
r = 8; % モデルの半径
t = 3; % モデル外側の厚み
rate = 2; % データサンプルの割合(%)

model = make_model(r,t);
for i = 1:100
    % 平面座標に関してランダムにサンプルをとりその座標のすべての周波数のデータを使う。
    [s_sample,sample,sample_list] = data_sample(s,rate);
    s_use = data_fill(s_sample,sample_list);
    
    [s_result,his,h_his,alpha_his,df_his] = gradient_descent(s_use,sample,model,p);
%     show_history_10_scaled(h_his,1,model);
    filename = horzcat('result/', dataname, '/1_', num2str(rate), '%/result', num2str(i));
    save(filename);
end
