% 関数の試しなど

clc; close all force;

fig = figure;
fig.Position = [0 660 1960 240];
s = rand(21,21,15) + 1i * rand(21,21,15);
for i = 1:15
subplot(2,15,i); imagesc(abs(s(:,:,i)));
subplot(2,15,i+15); imagesc(angle(s(:,:,i)));
end