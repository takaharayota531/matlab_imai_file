function [s_use,s,sample,sample_list] = data_sample_all(s,ratio)
[Nx,Ny,Nf] = size(s);
n = floor(Nx*Ny*Nf*ratio/100); % 選ぶ点の個数を計算
sample_tmp = sort(randsample(Nx*Ny*Nf,n))'; % すべての点のうちn個の点を選ぶ

sample_list = [floor((sample_tmp-1)/Ny/Nf)+1;floor(rem(sample_tmp-1,Ny*Nf)/Nf)+1;rem(sample_tmp-1,Nf)+1]; % 通し番号を座標に変換

sample = zeros(Nx,Ny,Nf);
i = 1;
for x = 1:Nx
    for y = 1:Ny
        for f = 1:Nf
            if i<=n && x==sample_list(1,i) && y==sample_list(2,i) && f==sample_list(3,i)
                sample(x,y,f) = 1;
                i = i+1;
            else
                s(x,y,f) = 0;
            end
        end
    end
end
s_a = abs(s);
s_a_use = zeros(Nx,Ny,Nf);
s_d_use = zeros(Nx,Ny,Nf);
for x = 1:Nx
    for y = 1:Ny
        for f = 1:Nf
            [s_a_use(x,y,f),s_d_use(x,y,f)] = fill_exp(s_a(:,:,f),s(:,:,f),x,y,f,sample_list);
        end
    end
end
s_use = s_a_use.*exp(1i*angle(s_d_use));
end

function [a,d] = fill_exp(s_a,s_d,x,y,f,sample_list)
rr = 0; %重みづけの分母
a = 0; %振幅
d = 0; %位相用の複素データ
col = find(sample_list(3,:)==f);
tmp_list = sample_list([1 2],sample_list(3,:)==f);
amp = 0.05; %重みづけのパラメータ
n = size(tmp_list,2);
r = zeros(n,1);
for k = 1:n
    r(k) = sqrt((tmp_list(1,k)-x)^2+(tmp_list(2,k)-y)^2); %距離
    rr = rr + exp(-amp*r(k)^2);
end
for k = 1:n
    a = a + exp(-amp*r(k)^2)/rr*s_a(tmp_list(1,k),tmp_list(2,k));
    d = d + exp(-amp*r(k)^2)/rr*s_d(tmp_list(1,k),tmp_list(2,k));
end
end