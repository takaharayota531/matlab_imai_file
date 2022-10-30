function show_all_class(c,w_points,varargin)
% c - class data
% w_points - number of reference classes
% x - x-axis vector
% y - y-axis vector
% z - z-axis vector
% fig - figure window for class distribution

if size(varargin,2) == 0
    x = 1:Nx;
    y = 1:Ny;
    z = 1:Nz;
    fig = figure;
elseif size(varargin,2) == 1
    x = 1:Nx;
    y = 1:Ny;
    z = 1:Nz;
    fig = varargin{1};
    figure(fig);
elseif size(varargin,2) == 3
    x = varargin{1};
    y = varargin{2};
    z = varargin{3};
    fig = figure;
elseif size(varargin,2) == 4
    x = varargin{1};
    y = varargin{2};
    z = varargin{3};
    fig = varargin{4};
    figure(fig);
end
col = floor((w_points+1)^(2/3));
row = ceil(w_points/col);
left_m = 0.03; % 左側余白の割合
bot_m = 0.1; % 下側余白の割合
ver_r = 1.3; % 縦方向余裕 (値が大きいほど各axes間の余白が大きくなる)
col_r = 1.15; % 横方向余裕 (値が大きいほど各axes間の余白が大きくなる)

figure_size = [ 0, 0, 1960, 1000];
set(fig, 'Position', figure_size);

for n =1:1:w_points
    % Position は、各Axes に対し、 [左下(x), 左下(y) 幅, 高さ] を指定
    subplot('Position',...
        [(1-left_m)*(mod(n-1,col))/col + left_m ,...
        (1-bot_m)*(1-ceil(n/col)/(row)) + bot_m ,...
        (1-left_m)/(col*col_r ),...
        (1-bot_m)/(row*ver_r)]...
        );
    % plotしたいものを書いてください***********
    index = find(c==n); % n番目のclassを検索
    [index_x,index_y,index_z] = ind2sub([Nx,Ny,Nz],index); % 線形インデックスを座標に変換
    ax = gca;
    scatter3(ax,x(index_x),y(index_y),z(index_z)); % 3次元散布図
    % 各軸の設定
    xlabel("x"); xlim([min(x) max(x)]);
    ylabel("y"); ylim([min(y) max(y)]);
    zlabel("z"); zlim([min(z) max(z)]);
    ax.ZDir = 'reverse';
    title(horzcat('class',num2str(n)));
end