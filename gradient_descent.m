%再急降下法
%sのノルムが一定になるように最適化

function [s,his,h_his,alpha_his,df_his] = gradient_descent(s,sample,model,p) % 散乱画像，ウィンドウサイズ，モデルサイズ

Ns = sum(sample(:,:,1),'all'); %取り出したデータの数
m = size(model,1);

h = calc_h(s,model);

[Nx,Ny,Nf] = size(s);
his = s;
h_his = h;
alpha_his = zeros(0,0);
df_his = zeros(Nx,Ny,Nf,2,0);

i = 0

while (i<10)
    df = calc_df(s,h,model,p);
    d = -2*squeeze(df(:,:,:,2));%.*~sample;
    
    alpha = armijo(d,df,his(:,:,:,end),model,p);
    
    s = s + alpha*d;
    h = calc_h(s,model);
    
    alpha_his(end+1) = alpha;
    df_his(:,:,:,:,end+1) = df;
    his(:,:,:,end+1) = s;
    h_his(:,:,end+1) = h;
    
    if alpha<1e-6
        break;
    end
    
    i = i+1
end

end
