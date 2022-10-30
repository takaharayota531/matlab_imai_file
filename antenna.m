clc; close all; clear;

fileID = fopen('BIG.txt','r');
formatSpec = '%d %f %f';
H1 = fscanf(fileID,formatSpec,[3 inf]);
fclose(fileID);

fileID = fopen('SMALL.txt','r');
formatSpec = '%d %f %f';
H2 = fscanf(fileID,formatSpec,[3 inf]);
fclose(fileID);

fileID = fopen('NORMAL.txt','r');
formatSpec = '%d %f %f';
H3 = fscanf(fileID,formatSpec,[3 inf]);
fclose(fileID);

figure; plot(H1(2,:),H1(3,:),H2(2,:),H2(3,:),H3(2,:),H3(3,:));
ylim([-40 0]);
xlabel('frequency[Hz]');
ylabel('magnitude(S11)[dB]');
legend('big','small','normal');
exportgraphics(gcf,'figures/S11.png');

%%
fileID = fopen('S11(1-21GHz-401Pts).txt','r');
formatSpec = '%d %f %f';
H = fscanf(fileID,formatSpec,[3 inf]);
fclose(fileID);

figure; plot(H(2,:),H(3,:));
ylim([-40 0]);
xlabel('frequency[Hz]');
ylabel('magnitude(S11)[dB]');
exportgraphics(gcf,'figures/S11.png');

%% アンテナの配置による直接結合の差をみる
clear; clc; close all;
% 直線状に配置した場合
fileID = fopen('PLANE.txt','r');
formatSpec = '%d %f %f %f';
H1 = fscanf(fileID,formatSpec,[4 inf]);
fclose(fileID);

f = H1(2,:)*1e9;
df = f(2)-f(1);

% 平行に配置した場合
fileID = fopen('PARA.txt','r');
formatSpec = '%d %f %f %f';
H2 = fscanf(fileID,formatSpec,[4 inf]);
fclose(fileID);

% figure; plot(H1(2,:),H1(3,:),H2(2,:),H2(3,:));
% ylim([-60 0]);
% xlabel('frequency[Hz]');
% ylabel('magnitude(S21)[dB]');
% legend('straight','parallel');
% exportgraphics(gcf,'figures/dc.png');

% figure; plot(H1(2,:),H1(4,:)/180*pi,H2(2,:),H2(4,:)/180*pi);
% ylim([-pi pi]);
% xlabel('frequency[Hz]');
% ylabel('phase(S21)[rad]');
% legend('straight','parallel');
% exportgraphics(gcf,'figures/dc.png');

S1 = db2mag(H1(3,:)).*exp(1i*H1(4,:)/180*pi);
S2 = db2mag(H2(3,:)).*exp(1i*H2(4,:)/180*pi);

f = 0:df:max(f);
Ef = size(f,2);
N = 1024;
T = 1/df;
dt = T/1024;
c = 299797482;
t = 0:dt:T-dt;
l = t*c;
S1f = zeros(1,1024);
S2f = zeros(1,1024);
index = find(f>=1e9 & f<=21e9);
S1f(index) = S1;
S2f(index) = S2;
T1 = fft(S1f,N);
T2 = fft(S2f,N);

figure; plot(l,abs(T1),l,abs(T2));
xlabel('distance[m]');
legend('straight','parallel');
xlim([0 3]);