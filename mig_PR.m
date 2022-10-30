function [pr_x,pr_y,pr_z,fx_use,fy_use,fz_use] = mig_PR(B,x,y,z,f)
Nfft = 1024;
nu = physconst('lightspeed');

[Nx,Ny,Nz] = size(B);
Nf = numel(f);

dx = x(2)-x(1);
dy = y(2)-y(1);
dz = z(2)-z(1);
Nbz = round(z(1)/dz); % blank of z
x = 0:dx:dx*(Nfft-1);
y = 0:dy:dy*(Nfft-1);
z = 0:dz:dz*(Nfft-1);

Fx = 1/(dx/nu);
Fy = 1/(dy/nu);
Fz = 1/(dz/nu);

dfx = Fx/Nfft;
dfy = Fy/Nfft;
dfz = Fz/Nfft;

fx = 0:dfx:dfx*(Nfft-1);
fy = 0:dfy:dfy*(Nfft-1);
fz = 0:dfz:dfz*(Nfft-1);

f_indx = find(f(1)<fx & fx<f(end));
f_indy = find(f(1)<fy & fy<f(end));
f_indz = find(f(1)<fz & fz<f(end));

[~,I] = max(abs(B),[],'all');
[xm,ym,zm] = ind2sub([Nx,Ny,Nz],I);
tdata_x = zeros(1,Nfft);
tdata_y = zeros(1,Nfft);
tdata_z = zeros(1,Nfft);

tdata_x(1:Nx) = B(:,ym,zm);
tdata_y(1:Ny) = B(xm,:,zm);
tdata_z(Nbz+1:Nbz+Nz) = B(xm,ym,:);

tdata_x = circshift(tdata_x,-xm+1,2).*gaussian(x,0.06);
tdata_y = circshift(tdata_y,-ym+1,2).*gaussian(y,0.06);
tdata_z = circshift(tdata_z,-zm-Nbz+1,2).*gaussian(z,0.03);

fdata_x = fft(tdata_x,Nfft);
fdata_y = fft(tdata_y,Nfft);
fdata_z = fft(tdata_z,Nfft);

pr_x = fdata_x(f_indx);
pr_y = fdata_y(f_indy);
pr_z = fdata_z(f_indz);

fx_use = fx(f_indx);
fy_use = fy(f_indy);
fz_use = fz(f_indz);
end

% index(1)を頂点とするガウス関数出力
function f = gaussian(x,s)
N = numel(x);
Nxc = floor(N/2);
f = exp(-(x-x(Nxc)).^2/2/s^2); % ガウス分布
f = circshift(f,-Nxc+1,2);
f = reshape(f,[1,N]);
end