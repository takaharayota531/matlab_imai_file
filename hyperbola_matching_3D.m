% hyperbola matching

clc; clear; close all;

global C
C = 299792458; % 光速(m/s)
DX = 5e-3; % 計測間隔(m)
DZ = 1e-3;
CUT_DISTANCE1 = 0.2; % 解析範囲の下限値（m）
CUT_DISTANCE2 = 1.0; % 解析範囲の上限値（m）

% load measured data
% [s,f] = data_load_XY_raw('20211218_yellow_3cm');
[s,f] = data_load_XY_raw('20220126_yellow_3cm');
f = f*1e9;

index = 1:200; % select frequency
s = s(:,:,index);
f = f(index);

z = CUT_DISTANCE1:DZ:CUT_DISTANCE2;
Nz = size(z,2);
t = z/C;
Nt = Nz;
[Nx,Ny,Nf] = size(s);

%% 深さ方向へ変換
disp('Transforming to time domain')
fr = reshape(f,1,1,1,Nf);
s = reshape(s,Nx,Ny,1,Nf);
z = reshape(z,1,1,Nz);
p = zeros(Nx,Ny,Nz);
lamda = C/fr;
for xp = 1:Nx
    R = 2*z; % path length
    temp = s(xp,:,:,:).*exp(-1i*2*pi*fr.*R/C); % rotation of phase;
    %         temp = temp./(lamda./(2*pi*R)).^2; % correct attenuation of signals
    p(xp,:,:) = sum(temp,4); % sum signals from all antenna positions
end

x = (0:Nx-1)*DX;
y = (0:Ny-1)*DX;

% show_rawdata(s(:,:,N_head+1:N_head+FREQ_POINT)); % 全表示
% show_volume(abs(p),x,y,z,jet,1);
%% hyperbola filter
% Nx = 1024;
% x = 0:DX:DX*Nx;
sigma = 1.0*1e-11;
alpha = 3e2;
a = 2;
p_filtered = zeros(Nx,Ny,Nt);

bar = waitbar(0,'Hyperbola matching...');

dt = 1/Nt;

for ti = 1:Nt
    h = make_filter(Nx,Ny,Nt,x,y,t,t(ti),alpha,sigma);
    for xi = 1:Nx
        for yi = 1:Ny
            filter = circshift(h,[xi-Nx/2 yi-Ny/2]);
            if xi-Nx/2<0
                filter(:,Nx+(xi-Nx/2)+1:Nx) = 0;
            elseif xi-Nx/2>0
                filter(:,1:xi-Nx/2) = 0;
            end

            if yi-Ny/2<0
                filter(:,Ny+(yi-Ny/2)+1:Ny) = 0;
            elseif yi-Ny/2>0
                filter(:,1:yi-Ny/2) = 0;
            end

            p_filtered(xi,yi,ti) = sum(p.*filter,'all');
        end
    end
        waitbar(dt*ti,bar,'Hyperbola matching...');
end

close(bar);
show_volume(abs(p_filtered),x,y,z,jet,1)
% imagesc(abs(p_filtered));
% plot(calc_r(sigma,t-calc_g(a,f,x0,x0,t0)))

%% test;
sigma = 1.0*1e-11;
alpha = 3e2;
a = 2;

% imagesc(make_filter(Nx,Ny,Nt,x,y,t,t(100),100,sigma*1e+1));
% filter = make_filter(Nx,Ny,Nt,x,y,t,t(100),alpha,sigma);
% show_volume(filter,x,y,z,jet,1);

function h = make_filter(Nx,Ny,Nt,x,y,t,t0,alpha,sigma)
h = zeros(Nx,Ny,Nt); % hyperbola filter
xi = reshape(x,Nx,1,1);
yi = reshape(y,1,Ny,1);
ti = reshape(t,1,1,Nt);
h = exp(-alpha*((x(Nx/2)-xi).^2+(y(Ny/2)-yi).^2)).*calc_r(sigma,ti-calc_g(xi,yi,x(Nx/2),y(Ny/2),t0));
h(abs(h)<0.1) = 0; 
end

function g = calc_g(x,y,x0,y0,t0)
% g = a*sqrt(f^2+(x-x0).^2)+t0-f*a;
global C
g = sqrt(t0^2+((x-x0)/C).^2+((y-y0)/C).^2);
end

function r = calc_r(sigma,t)
r = 2/sqrt(3*sigma)/pi^(0.25)*(1-t.^2/sigma^2).*exp(-t.^2/2/sigma^2);
end
