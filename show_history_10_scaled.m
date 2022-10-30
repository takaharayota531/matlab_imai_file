function show_history_10_scaled(data,l,model)
m = size(model,1);
n = size(data,3);

fontsize = 18;

data_max = max(data,[],'all');
data_min = min(data,[],'all');

row = 2; % subplot行数
col = ceil(n/2); % subplot列数
left_m = 0.01; % 左側余白の割合
bot_m = 0.01; % 下側余白の割合
ver_r = 1; % 縦方向余裕 (値が大きいほど各axes間の余白が大きくなる)
col_r = 1.3; % 横方向余裕 (値が大きいほど各axes間の余白が大きくなる)
bar_w = 0;%1/col/2;

figure_size = [ 0, 160, 1960, 1960/col/col_r*1.2*row];
figure;
set(gcf, 'Position', figure_size);

for n =1:1:n
    % Position は、各Axes に対し、 [左下(x), 左下(y) 幅, 高さ] を指定
    subplot('Position',...
        [(1-left_m-bar_w*col_r)*(mod(n-1,col))/col + left_m ,...
        (1-bot_m)*(1-ceil(n/col)/(row)) + bot_m ,...
        (1-left_m-bar_w*col_r)/(col*col_r ),...
        (1-bot_m)/(row*ver_r)]...
        );
    % plotしたいものを書いてください***********
    ti = horzcat('$t=',num2str(n-1),'$');
    data_min = min(abs(data(:,:,n)),[],'all');
    data_max = max(abs(data(:,:,n)),[],'all');
    imshow(abs(data(:,:,n)),'DisplayRange',[data_min data_max],'Colormap',parula(4096));
    title(ti,'FontSize',fontsize,'FontName','SansSerif','Interpreter','latex');
    colorbar('FontSize',fontsize);
end
