% 初期参照ベクトルの生成
function w = w_init(data,w_points)
dim = size(data);
N = 1;
for i = 1:(size(dim,2)-1)
    N = N * dim(i);
end
data = reshape(data,[N dim(end)]); % 座標×周波数の２次元配列に変形
S = std(data); % 周波数ごとの分散
A = mean(data); % 周波数ごとの平均
w = A.' + S.'.*(randn(dim(end),w_points)+1i*randn(dim(end),w_points)); % 入力データの分布に応じた初期値を生成
% w = A'+S'.*randn(dim(end),w_points).*1i*2*pi*(rand(dim(end),w_points)-0.5); % 入力データの分布に応じた初期値を生成