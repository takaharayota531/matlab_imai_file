% hyperbola matching

clc; clear; close all force;

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

s = s(:,:,1:200);
f = f(1:200);

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
    for yp = 1:Ny
        R = 2*z; % path length
        temp = s(xp,yp,:,:).*exp(-1i*2*pi*fr.*R/C); % rotation of phase;
%         temp = temp./(lamda./(2*pi*R)).^2; % correct attenuation of signals
        p(xp,yp,:) = sum(temp,4); % sum signals from all antenna positions
    end
end

x = (0:Nx-1)*DX;
y = (0:Ny-1)*DX;

% show_rawdata(s(:,:,N_head+1:N_head+FREQ_POINT)); % 全表示
show_volume(abs(p),x,y,z,jet,1);
%% hyperbola filter
% Nx = 1024;
% x = 0:DX:DX*Nx;
sigma = 1.0*1e-11;
alpha = 1e2;
a = 2;
p = squeeze(p(1,:,:))';
p_filtered = zeros(Nt,Nx);

for ti = 1:Nt
    h = make_filter(Nx,Nt,x,t,t(ti),alpha,sigma);
    for xi = 1:Nx
        filter = circshift(h,xi-Nx/2,2);
        if xi-Nx/2<0
            filter(:,Nx+(xi-Nx/2)+1:Nx) = 0;
        elseif xi-Nx/2>0
            filter(:,1:xi-Nx/2) = 0;
        end
        p_filtered(ti,xi) = sum(p.*filter,'all');
    end
end

imagesc(abs(p_filtered));
% plot(calc_r(sigma,t-calc_g(a,f,x0,x0,t0)))

%% test
imagesc(make_filter(Nx,Nt,x,t,t(100),100,sigma));

%% functions
function h = make_filter(Nx,Nt,x,t,t0,alpha,sigma)
h = zeros(Nt,Nx); % hyperbola filter
for xi = 1:Nx
    for ti = 1:Nt
        h(ti,xi) = exp(-alpha*(x(Nx/2)-x(xi))^2)*calc_r(sigma,t(ti)-calc_g(x(xi),x(Nx/2),t0));
    end
end
end

function g = calc_g(x,x0,t0)
% g = a*sqrt(f^2+(x-x0).^2)+t0-f*a;
global C
g = sqrt(t0^2+((x-x0)/C).^2);
end

function r = calc_r(sigma,t)
r = 2/sqrt(3*sigma)/pi^(0.25)*(1-t.^2/sigma^2).*exp(-t.^2/2/sigma^2);
end
