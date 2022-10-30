function show_all_depth(c,cmap,varargin)
% figureが指定されていればそれをアクティブ化，そうでなければ新しいfigureを作成
if size(varargin,2) == 0
    fig = figure;
else
    fig = varargin{1};
    figure(fig);
end

[Nx,Ny,Nz] = size(c);
col = floor((Nz+1)^(2/3));
row = ceil(Nz/col);
left_m = 0.03; % 左側余白の割合
bot_m = 0.1; % 下側余白の割合
ver_r = 1.3; % 縦方向余裕 (値が大きいほど各axes間の余白が大きくなる)
col_r = 1.15; % 横方向余裕 (値が大きいほど各axes間の余白が大きくなる)

figure_size = [ 0, 0, 1960, 1000];
colormap(cmap);
Clims = [min(c,[],'all') max(c,[],'all')];
set(fig, 'Position', figure_size);

for n =1:1:Nz+1
    % Position は、各Axes に対し、 [左下(x), 左下(y) 幅, 高さ] を指定
    subplot('Position',...
        [(1-left_m)*(mod(n-1,col))/col + left_m ,...
        (1-bot_m)*(1-ceil(n/col)/(row)) + bot_m ,...
        (1-left_m)/(col*col_r ),...
        (1-bot_m)/(row*ver_r)]...
        );
    % plotしたいものを書いてください***********
    if(n<Nz+1)
    ax = gca;
    imagesc(ax,c(:,:,n),Clims);
    title(horzcat('z = ',num2str(n)));
    else
        colorbar;
        caxis(Clims);
    end
end