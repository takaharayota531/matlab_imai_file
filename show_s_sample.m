function show_s_sample(data)
Nf = size(data,3);

c_a = jet(4096);
c_a(1,:) = [1 1 1];
c_p = hsv(4096);
c_p(2049,:) = [1 1 1];

row = 2; % subplot行数
col = Nf; % subplot列数
left_m = 0.01; % 左側余白の割合
bot_m = 0.1; % 下側余白の割合
ver_r = 1.3; % 縦方向余裕 (値が大きいほど各axes間の余白が大きくなる)
col_r = 1.15; % 横方向余裕 (値が大きいほど各axes間の余白が大きくなる)
bar_w = 1/col/2;

figure_size = [ 0, 200, 1960, 1960/Nf*1.2*row];
figure;
set(gcf, 'Position', figure_size);

data_max = max(abs(data),[],'all'); %周波数ごとに最大値、最小値を設定する
data_min = min(abs(data),[],'all');

for n =1:1:row*col
    % Position は、各Axes に対し、 [左下(x), 左下(y) 幅, 高さ] を指定
    subplot('Position',...
        [(1-left_m-bar_w*col_r)*(mod(n-1,col))/col + left_m ,...
        (1-bot_m)*(1-ceil(n/col)/(row)) + bot_m ,...
        (1-left_m-bar_w*col_r)/(col*col_r ),...
        (1-bot_m)/(row*ver_r)]...
        );
    % plotしたいものを書いてください***********
    if n<=Nf
        I = abs(data(:,:,n));
        RI = imref2d(size(I));
        imshow(I,RI,'DisplayRange',[data_min data_max],'Colormap',c_a); box on;
    else
        I = angle(data(:,:,n-Nf));
        RI = imref2d(size(I));
        imshow(I,RI,'DisplayRange',[-pi pi],'Colormap',c_p); box on;
    end
end
subplot('Position',...
        [(1-left_m-bar_w*col_r) ,...
        (1-bot_m)/2 + bot_m ,...
        bar_w/col_r-left_m*2,...
        (1-bot_m)/(row*ver_r)] ,...
        'Visible' ,'off' ,...
        'Fontsize',20 ,...
    'Colormap',c_a);
c = colorbar('Position',[0 0 1 1],'location','east');
c.Label.String = 'Amplitude[arb.unit]';
caxis([data_min data_max]);

subplot('Position',...
        [(1-left_m-bar_w*col_r) ,...
        bot_m ,...
        bar_w/col_r-left_m*2,...
        (1-bot_m)/(row*ver_r)] ,...
        'Visible' ,'off' ,...
        'Fontsize',20 ,...
        'Colormap',c_p);
c = colorbar('Position',[0 0 1 1],'location','east');
c.Label.String = 'Phase[rad]';
caxis([-pi pi]);