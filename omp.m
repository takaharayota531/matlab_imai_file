function [x,res] = omp(y,A,k)
[m,N] = size(A);
Nf = size(y,2);
x = zeros(N,Nf); %復元するスパース信号の初期値はすべて0
res = y; %初期値は受信信号
cor = zeros(N,Nf);
column = [];
for i=1:k
    for f = 1:Nf
        cor(:,f) = abs(A'*res(:,f));
    end
    [c,n] = max(sqrt(sum(cor.*conj(cor),2))); %内積をとり受信信号と関連の強い列を選択
    column(end+1) = n; % end+1 で配列の後ろに要素を追加できる　先ほど選択した列番号を追加
    for f = 1:Nf
        x(column,f) = pinv(A(:,column))*y(:,f); %pinv():疑似逆行列　スパース行列の計算
    end
    res = y - A(:,column)*x(column,:);
end
end