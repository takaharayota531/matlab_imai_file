function s = data_fill(s,sample_list)
[Nx,Ny,Nf] = size(s);
s_d = s;
s_a = abs(s); %絶対値をとる
for f = 1:Nf
    for x = 1:Nx
        for y = 1:Ny
            if search_sample(x,y,sample_list) == 0
                [s_a(x,y,f),s_d(x,y,f)] = fill_exp(s_a(:,:,f),s_d(:,:,f),x,y,sample_list);
            end
        end
    end
end
s_p = angle(s_d);
s = s_a.*exp(1i*s_p);

%点回り5×5の範囲内の平均をとる
function [a,d] = fill_square(s_a,s_d,x,y,sample_list)
a = 0;
d = 0;
n = 0; %範囲内の非零の数
[Xlen,Ylen] = size(s_a);
for i = x-2:x+2
    for j = y-2:y+2
        if i>0 && j>0 && i<Xlen+1 && j<Ylen+1 && search_sample(x,y,sample_list) == 1
            n = n+1;
            a = a+ s_a(i,j);
            d = d+ s_d(i,j);
        end
    end
end
a = a/n;
d = d/n;

function [a,d] = fill_exp(s_a,s_d,x,y,sample_list)
rr = 0; %重みづけの分母
a = 0; %振幅
d = 0; %位相用の複素データ
amp = 0.05; %重みづけのパラメータ
n = size(sample_list,2);
r = zeros(n,1);
if search_sample(x,y,sample_list) == 0
    for k = 1:n
        r(k) = sqrt((sample_list(1,k)-x)^2+(sample_list(2,k)-y)^2); %距離
        rr = rr + exp(-amp*r(k)^2);
    end
    for k = 1:n
        a = a + exp(-amp*r(k)^2)/rr*s_a(sample_list(1,k),sample_list(2,k));
        d = d + exp(-amp*r(k)^2)/rr*s_d(sample_list(1,k),sample_list(2,k));
    end
end

function a = search_sample(x,y,sample_list)
n = size(sample_list,2);
a = 0;
for i = 1:n
    if x == sample_list(1,i) && y == sample_list(2,i)
        a = 1;
    end
end
