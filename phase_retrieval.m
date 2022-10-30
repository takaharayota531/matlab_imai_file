function PR = phase_retrieval(S,V,Nfft,l,ind,indf)
% variable

% S - input signal in 3D
% V - standard deviation of gaussian
% ind - index of depth for phase retrieval
% indf - index of retrieved phase in frequency

disp('Phase retrieving');

[Nx,Ny,~] = size(S);
Nf = numel(indf);
N_pr = numel(ind);

PR = zeros(Nx,Ny,N_pr,Nf);
i = 0;

% dp = reshape(2*pi*dl/nu*(f),[1,1,Nf]); % １ピクセルあたりの各周波数での位相回転

zo = 1; % zero点位置
win = gaussian(l,V); % ガウスウィンドウ
% win = square_win(l,V); % 矩形ウィンドウ
% plot(l,squeeze(win));
% ガウス窓で空間全体を掃引して位相復元
for iz = ind
    i = i+1;
    win_fun = circshift(win,iz-1,3); % ガウスウィンドウ作成
    F_gau = S.*complex(win_fun); % dataにガウスフィルターを適用
    F_shift = circshift(F_gau,-iz+zo,3); % t=0(z=0)にシフト
    complex_r = fft(F_shift,Nfft,3); % 周波数領域に変換
    complex_r = complex_r(:,:,indf); % 計測した周波数のみを取り出す。
    PR(:,:,i,:) = reshape(complex_r,Nx,Ny,1,[]);
end

end

% index(1)を頂点とするガウス関数出力
function f = gaussian(x,s)
N = size(x,2);
Nxc = floor(N/2);
f = exp(-(x-x(Nxc)).^2/2/s^2); % ガウス分布
f = circshift(f,-Nxc+1,2);
f = reshape(f,[1,1,N]);
end

% index(1)を中心とする矩形フィルター
function f = square_win(x,s)
N = numel(x);
Nxc = floor(N/2);
f = zeros(size(x));
f(find(x<(x(Nxc)+s) & x>(x(Nxc)-s))) = 1;
f = circshift(f,-Nxc+1,2);
f = reshape(f,[1,1,N]);
end