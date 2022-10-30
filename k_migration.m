% kirchhoff migration

function B = k_migration(A,x,y,z,t,t_ind)

disp('migrating...')
bar = waitbar(0,'Migrating');
tic;

dt = t(2)-t(1); % 時間分解能取得
dz = z(2)-z(1); % 深さ分解能取得
nu = physconst('Lightspeed'); % 光速
[Nx,Ny,Nt] = size(A);
ut = 1/Nx/Ny;
Ap = (A(:,:,1:end-1)-A(:,:,2:end))/dt; % 時間領域で微分
xa = reshape(x,Nx,1,1);
ya = reshape(y,1,Ny,1);
ta = reshape(t,1,1,Nt);
dz = z(2)-z(1);
z = reshape(z,1,1,Nt);

Nti = size(t_ind,2);
B = zeros(Nx,Ny,Nti);

zb = reshape(z(t_ind),1,1,1,Nti);

for xb = 1:Nx
    for yb = 1:Ny
        R = sqrt((xa-x(xb)).^2+(ya-y(yb)).^2+zb.^2);
        theta = acos(zb./R);
        ind = find(round(z/dz)<=(2*R/dz) & (2*R/dz)<round(z/dz+1));
        [indx,indy,indza,indzb] = ind2sub([Nx,Ny,Nt,Nti],ind);
        a = 2*R-reshape(z(indza),Nx,Ny,1,Nti);
        b = reshape(z(indza),Nx,Ny,1,Nti)+dz-2*R;
        A1 = A; A1(~ind)=0; A1 = max(A1,[],3);
        A2=A; A2=circshift(A2,-1,3); A2(~ind)=0; A2=max(A2,[],3);
        Ap1 = A; Ap1(~ind)=0; Ap1 = max(Ap1,[],3);
        Ap2=A; Ap2=circshift(Ap2,-1,3); Ap2(~ind)=0; Ap2=max(Ap2,[],3);
        temp1 = (A1.*b+A2.*a)./(a+b); % Aの線形補間
        temp2 = (Ap1.*b+Ap2.*a)./(a+b); % Apの線形補間
        B(xb,yb,:) = sum(cos(theta)./R.^2.*temp1+cos(theta)/nu./R.*temp2,[1 2 3])/2/pi;

        waitbar(ut*(yb+Ny*(xb-1)),bar,'Migrating');
    end
end

close(bar);
toc;

end