[s,f] = data_load_XY_raw('20220126_yellow_3cm');
m = squeeze(mean(abs(s),[1 2]));

plot(f,mag2db(m));

%% 指向性を式で近似
 
clear; clc; close all force;

filename = 'directivity_ex_data.csv';
fileID = fopen(filename,'r');
formatSpec = '%d,%f';
A = fscanf(fileID,formatSpec,[2 inf]);

theta = A(1,:);
amp = 0.25*(A(2,:)-100);

npara = 8;
alpha = ones(1,npara);
C = ones(1,npara);
C(1) = 30;
C(2) = 3e-5;
C(3) = 5;
C(4) = 1e-7;
C(5) = 0.45; % 正弦波の周波数
C(6) = 50; % 正弦波の位相
C(7) = 1e-1;
C(8) = -18;

y1 = C(1)*exp(-C(2)*theta.^3); % 正面方向の出っ張り
y2 = C(3)*C(4)*theta.^4./(1+C(4)*theta.^4).*cos(C(5)*(theta+C(6))); % サイドの波部分
y3 = C(4)*theta.^4./(1+C(4)*theta.^4).*C(7).*theta+C(8); % サイドの波部分の傾き
y = y1+y2+y3;

plot(theta,y1,theta,y2,theta,y3);

figure;
plot(theta,amp,theta,y);

%% 位相復元もろもろ
K = ones(60,60,64,141);
f_use = (1:0.05:8)*1e9;
phase_rot = reshape(l(index_distance)-l(index_distance(numel(index_distance)/2)),1,1,[])/nu.*reshape(f_use,1,1,1,[])*2*pi;
K = K.*exp(-1i*phase_rot);

show_retrieved(K,f);

%% 多項式の根
h = 0.28;
zq = 0.03;
x = 0.1;
a4 = 1;
a3 = -2*(4*h^2+4*zq^2+3*x^2);
a2 = 16*h^4+4*zq^4+48*h^2*zq^2+12*x^2*(2*h^2+zq^2)+9*x^4;
a1 = -16*h^2*zq^2*(3*x^2+5*h^2+2*zq^2);
a0 = 64*h^4*zq^4;
p = [a4 a3 a2 a1 a0];
tic
A = roots(p);
toc
R_temp = sqrt((A-h^2)/3);
R1 = R_temp(h<R_temp & R_temp<sqrt(h^2+x^2));
R2 = 2*zq/sqrt(3-(h/R1)^2);
theta1 = asin(sqrt(1-h^2/R1^2));
theta2 = asin(sqrt(1-zq^2/R2^2));
n = sin(theta1)/sin(theta2);
x1 = R1*sin(theta1);
x2 = R2*sin(theta2);

%% tanを求める
% tan(theta_1/2)=t_1
% tan(theta_2/2)=t_2
clear t1 t2
syms t1 t2
h = 0.28;
z = 0.03;
x = 0.1;
eqns = [h*2*t1/(1-t1^2)+z*2*t2/(1-t2^2)==x, 2*t1/(1+t1^2)*(1+t2^2)/2/t2==2];
S = solve(eqns);
sol = [S.t1;S.t2]