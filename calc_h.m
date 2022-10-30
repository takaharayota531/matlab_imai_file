% 半径rの円の内部と外側を比較

function h = calc_h(k,model)
[Nx,Ny,k_dim] = size(k);
%すべてのモデルについて相関度を計算しそのモデルでの特徴ベクトルの平均をとる．
m = size(model,1);
r = floor(m/2);
h = zeros(Nx,Ny); %各モデルでの数値を格納
% Ix = [r:-1:1,1:Nx,Nx:-1:Nx-r+1];
% Iy = [r:-1:1 1:Ny Ny:-1:Ny-r+1];
Ix = [Nx-r+1:Nx,1:Nx,1:r];
Iy = [Ny-r+1:Ny,1:Ny,1:r];

for x = 1:Nx
    for y = 1:Ny
        kp = squeeze(sum((model==1).*k(Ix(x:x+m-1),Iy(y:y+m-1),:),[1 2]));
        km = squeeze(sum((model==-1).*k(Ix(x:x+m-1),Iy(y:y+m-1),:),[1 2]));
        h(x,y) = 1-real(kp'*km)/sqrt(kp'*kp)/sqrt(km'*km);
    end
end

[M I] = max(h,[],'all','linear');
pos = [mod(I,(Nx-m+1)) floor(I/(Nx-m+1))];
% display_position(pos,model,Nx);

end

function display_position(pos,model,N)
land = zeros(N,N);
Nm = size(model,1);
for x = 1:Nm
    for y = 1:Nm
        if model(x,y) == 1
            land(pos(1)+x-1,pos(2)+y-1) = 1;
        end
    end
end
figure;
imagesc(land);
colormap(gray);
end

    