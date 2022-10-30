clc; clear; close all force;

l = 4;
ratio = 2;
model = make_model(7,3);
filter = zeros(50,50);
m = size(model,1);
filter(1:m,1:m)=model;
figure;imagesc(filter);colormap(gray);colorbar;
% model = make_model_2(10);
m = size(model,1);
%データの読み込み
dataname = 'mine00';
dataHname = 'hosei00';
s = data_load_XY(dataname,dataHname);

[s_use,s_sample,sample,sample_list] = data_sample_all(s,ratio);

show_s(s_use);