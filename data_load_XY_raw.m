% XY-stageのデータを読み込む

function [s_use,f] = data_load_XY_raw(dataname)
disp('Data loading ...');
tic
filename = horzcat(dataname,'.txt');

fileID = fopen(filename,'r');
formatSpec = '%d %f %f %f %d %d';
A = fscanf(fileID,formatSpec,[6 inf]);

N = size(A,2);
Nx = A(6,end);
Ny = A(5,end);
Nf = N/Nx/Ny;
F_int = A(2,2)-A(2,1);
F_s = A(2,1);
data = zeros(Nx,Ny,Nf,2);
A([1 5 6],:) = round(A([1 5 6],:));

f = F_s+F_int:F_int:F_s+F_int*(Nf-1);

for i = 1:N
    data(A(6,i),A(5,i),rem(i-1,Nf)+1,1) = A(3,i);
    data(A(6,i),A(5,i),rem(i-1,Nf)+1,2) = A(4,i)/180*pi;
end
% dBでの散乱画像の表示
% show_s_dB(data(:,:,[2 11:10:101],:));

% 複素数に変換
data_comp = 10.^(data(:,:,:,1)/10).*exp(1i*data(:,:,:,2));

s = data_comp; % 振幅のdB化,正規化せずに使う

% データを10周波数ずつにすべて表示して保存する
% print_all(s,dataname);

s_use = s(:,:,2:end);
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