% calc_h_9用の偏微分計算

function df = calc_df(s,h,model,p)
[Nx,Ny,Nf] = size(s);
m = size(model,1);
dh = calc_dh(s,model);
df = sum_dh(h,dh,p);
end

function dh = calc_dh(s,model)
[Nx,Ny,Nf] = size(s);
m = size(model,1);
r = (m-1)/2;
% Ix = [r:-1:1,1:Nx,Nx:-1:Nx-r+1];
% Iy = [r:-1:1 1:Ny Ny:-1:Ny-r+1];
Ix = [Nx-r+1:Nx,1:Nx,1:r];
Iy = [Ny-r+1:Ny,1:Ny,1:r];

dh = zeros(Nx,Ny,m,m,Nf,2);
pmodel = model==1;
mmodel = model==-1;
for xh = 1:Nx
    for yh = 1:Ny
        st = s(Ix(xh:xh+m-1),Iy(yh:yh+m-1),:);
        dhp = zeros(m,m,Nf,2);
        dhm = zeros(m,m,Nf,2);
        kp = squeeze(sum(pmodel.*st,[1 2]));
        km = squeeze(sum(mmodel.*st,[1 2]));
        dkp = zeros(Nf,m,m,Nf);
        dkm = zeros(Nf,m,m,Nf);
        xs = 1:m;
        ys = 1:m;
        for f = 1:Nf
            dkp(f,xs,ys,f) = pmodel;
            dkm(f,xs,ys,f) = mmodel;
        end
        akp = sqrt(kp'*kp); % |kp|
        akm = sqrt(km'*km); % |km|
        kpn = kp/akp;
        kmn = km/akm;
        dakp = zeros(Nx,Ny,Nf,2); % |kp|の偏微分
        dakm = zeros(Nx,Ny,Nf,2); % |km|の偏微分
        f = 1:Nf;
        dakp(xs,ys,f,1) = squeeze(sum(dkp(:,xs,ys,f).*conj(kp),1)/2/akp).*pmodel;
        dakp(xs,ys,f,2) = squeeze(sum(conj(dkp(:,xs,ys,f)).*kp,1)/2/akp).*pmodel;
        dakm(xs,ys,f,1) = squeeze(sum(dkm(:,xs,ys,f).*conj(km),1)/2/akm).*mmodel;
        dakm(xs,ys,f,2) = squeeze(sum(conj(dkm(:,xs,ys,f)).*km,1)/2/akm).*mmodel;
        dkpn = zeros(Nf,m,m,Nf,2);
        dkmn = zeros(Nf,m,m,Nf,2);
        
        xs = 1:m;
        ys = 1:m;
        f = 1:Nf;
        dkmn(:,xs,ys,f,1) = (dkm(:,xs,ys,f)*akm-km.*reshape(dakm(xs,ys,f,1),1,m,m,Nf))/akm^2;
        dkmn(:,xs,ys,f,2) = (-km.*reshape(dakm(xs,ys,f,2),1,m,m,Nf))/akm^2;
        dhm(xs,ys,f,1) = -sum(conj(kpn).*dkmn(:,xs,ys,f,1)+kpn.*conj(dkmn(:,xs,ys,f,2)),1)/2;
        dhm(xs,ys,f,2) = -sum(conj(kpn).*dkmn(:,xs,ys,f,2)+kpn.*conj(dkmn(:,xs,ys,f,1)),1)/2;
        dhm(xs,ys,f,:) = dhm(xs,ys,f,:).*mmodel;
        
        dkpn(:,xs,ys,f,1) = (dkp(:,xs,ys,f)*akp-kp.*reshape(dakp(xs,ys,f,1),1,m,m,Nf))/akp^2;
        dkpn(:,xs,ys,f,2) = (-kp.*reshape(dakp(xs,ys,f,2),1,m,m,Nf))/akp^2;
        dhp(xs,ys,f,1) = -sum(conj(kmn).*dkpn(:,xs,ys,f,1)+kmn.*conj(dkpn(:,xs,ys,f,2)),1)/2;
        dhp(xs,ys,f,2) = -sum(conj(kmn).*dkpn(:,xs,ys,f,2)+kmn.*conj(dkpn(:,xs,ys,f,1)),1)/2;
        dhp(xs,ys,f,:) = dhp(xs,ys,f,:).*pmodel;

        dh(xh,yh,:,:,:,:) = dhp + dhm;

    end
end
end

function df = sum_dh(h,dh,p)
[Nx,Ny,m,Nf] = size(dh,1,2,3,5);
df = zeros(Nx,Ny,Nf,2);
r = (m-1)/2;
% Ix = [r:-1:1,1:Nx,Nx:-1:Nx-r+1];
% Iy = [r:-1:1 1:Ny Ny:-1:Ny-r+1];
Ix = [Nx-r+1:Nx,1:Nx,1:r];
Iy = [Ny-r+1:Ny,1:Ny,1:r];
for x = 1:Nx
    for y = 1:Ny
        df(Ix(x:x+m-1),Iy(y:y+m-1),:,:) = df(Ix(x:x+m-1),Iy(y:y+m-1),:,:)...
            + squeeze(p*h(x,y)^(p-1)*dh(x,y,:,:,:,:));
    end
end

end