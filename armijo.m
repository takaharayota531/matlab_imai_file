function alpha = armijo(d,df,s,model,p) % アルミホの条件からステップ幅を計算
alpha = 100;
c = 0.5;
rho = 0.5;
df1 = squeeze(df(:,:,:,1));
df2 = squeeze(df(:,:,:,2));
f = calc_f(s,model,p);
while 1
    fi = calc_f(s+alpha*d,model,p);
    fi2 = f + (sum(df1.*d,'all')+sum(df2.*conj(d),'all'))*c*alpha;
    if fi <= fi2 || alpha<1e-6
        break
    end
    alpha = alpha*rho;
end
end

function f = calc_f(s,model,p)
h = calc_h(s,model);
f = sum(abs(h).^p,'all');
end