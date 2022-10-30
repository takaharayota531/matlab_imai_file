% 位相補正の近似式 θ=af+b を計算する関数

function [a,b] = make_spiral(theta)
theta = theta';
theta = angle(theta);
% 初期値設定
a = -4;
b = 2;
f = 8:0.04:12;
theta = theta(1:20);
f = f(1:20);
ea = 0.1;
eb = 0.1;
alpha = 1e-4;
beta = 1e-2;
while 1
    e = sum(1-cos(a*f+b-theta));
    da = sum(f.*sin(a*f+b-theta)); % aで偏微分
    db = sum(sin(a*f+b-theta)); % bで偏微分
    if (abs(da) < ea) && (abs(db) < eb)
        break
    end
    a = a - alpha*da; % aの更新
    b = b - beta*db; % bの更新
end