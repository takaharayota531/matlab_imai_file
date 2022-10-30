% 

function sigma = calk_sigma(k)

row_num = size(k,1); %横
col_num = size(k,2); %縦

k_dim = size(k,4);
k_st = reshape(squeeze(k(1,1,1,:)),1,k_dim); % 最終的に観測点数(289)×kの次元数(14)になる。
for y = 2:col_num
    k_st = [k_st;reshape(squeeze(k(1,y,1,:)),1,k_dim)];
end    
for x = 2:row_num
    for y = 1:col_num
        k_st = [k_st;reshape(squeeze(k(x,y,1,:)),1,k_dim)];
    end
end
% size(k_st) 
sigma = cov(k_st); %kの各要素について分散共分散行列の計算