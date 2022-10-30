% XY-stageのデータを読み込む

function [s_use,f] = data_load_XY(dataname,datanameH)
disp('Data loading ...');
tic
filename = horzcat(dataname,'.txt');
filenameH = horzcat(datanameH,'.txt');

fileID = fopen(filename,'r');
formatSpec = '%d %f %f %f %d %d';
A = fscanf(fileID,formatSpec,[6 inf]);
fileID = fopen(filenameH,'r');
formatSpec = '%d %f %f %f %d %d';
H = fscanf(fileID,formatSpec,[6 inf]);

N = size(A,2);
Nx = A(6,end);
Ny = A(5,end);
Nf = N/Nx/Ny;
F_int = A(2,2)-A(2,1);
F_s = A(2,1);
f = squeeze(A(2,1:Nf));
data = zeros(Nx,Ny,Nf,2);
A([1 5 6],:) = round(A([1 5 6],:));

for i = 1:N
    data(A(6,i),A(5,i),rem(i-1,Nf)+1,1) = A(3,i);
    data(A(6,i),A(5,i),rem(i-1,Nf)+1,2) = A(4,i)/180*pi;
end
% dBでの散乱画像の表示
% show_s_dB(data(:,:,[2 11:10:101],:));

dataH = zeros(1,1,Nf,2);
for i = 1:Nf
    dataH(1,1,i,1) = H(3,i);
    dataH(1,1,i,2) = H(4,i)/180*pi;
end
% data(:,:,:,2) = data(:,:,:,2)-dataH(1,1,:,2); % 位相のみの引き算（アンテナの位相中心分の補正)
% dataH(:,:,:,2) = dataH(:,:,:,2)-dataH(1,1,:,2); % 位相のみの引き算（アンテナの位相中心分の補正)

% 複素数に変換
data_comp = 10.^(data(:,:,:,1)/10).*exp(1i*data(:,:,:,2));
dataH_comp = 10.^(dataH(1,1,:,1)/10).*exp(1i*dataH(1,1,:,2));

% 補正用のデータを複素で引く
data_comp = data_comp - dataH_comp;

% dataを振幅と位相に分解
% data(:,:,:,1) = mag2db(abs(data_comp));
% data(:,:,:,2) = angle(data_comp);
% 
% data = standard(data); % 振幅[dB]の最小値を0，中央値を1にする

% 振幅をdBのまま複素数に変換
s = data(:,:,:,1).*exp(1i*data(:,:,:,2));
s = data_comp; % 振幅のdB化,正規化せずに使う 
% データを10周波数ずつにすべて表示して保存する
% print_all(s,dataname);

% 使用する周波数を選ぶ
% s_use = s(:,:,62:2:81);
% s_use = s(:,:,[2 11:10:101]);
% s_use = s(:,:,2:2:20); % 大体8.0~8.8GHz
s_use = s(:,:,2:end);
f = f(2:end);
toc
end

function print_all(data,dataname)
for i = 0:9
    show_s(data(:,:,10*i+2:10*(i+1)+1));
    bn = num2str(10*i+2);
    ed = num2str(10*(i+1)+1);
    filename = horzcat('figures\',dataname,'\',bn,'-',ed,'.png');
    saveas(gcf,filename);
end
end

function data = standard(data)
temp = data(:,:,2:end,1);
dmed = median(temp,'all');
dmin = min(temp,[],'all');
dmag = dmed-dmin;
data(:,:,2:end,1) = (temp-dmin)/dmag;
end