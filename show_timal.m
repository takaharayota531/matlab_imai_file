function show_timal(s,t)
col = 1;
row = 2;
left_m = 0.03; % 左側余白の割合
bot_m = 0.1; % 下側余白の割合
ver_r = 1.3; % 縦方向余裕 (値が大きいほど各axes間の余白が大きくなる)
col_r = 1.05; % 横方向余裕 (値が大きいほど各axes間の余白が大きくなる)

figure_size = [ 200, 200, 800, 500];
figure('Position', figure_size);
for n =1:1:2
    % Position は、各Axes に対し、 [左下(x), 左下(y) 幅, 高さ] を指定
    ax(n) = subplot('Position',...
        [(1-left_m)*(mod(n-1,col))/col + left_m ,...
        (1-bot_m)*(1-ceil(n/col)/(row)) + bot_m ,...
        (1-left_m)/(col*col_r ),...
        (1-bot_m)/(row*ver_r)]...
        );
    % plotしたいものを書いてください***********
    if n==1
        plot(t,abs(s));
        xlabel('Time[s]','FontName','SansSerif','Interpreter','latex');
        ylabel('Amplitude','FontName','SansSerif','Interpreter','latex');
    else
        plot(t,angle(s));
        xlabel('Time[s]','FontName','SansSerif','Interpreter','latex');
        ylabel('Phase[rad]','FontName','SansSerif','Interpreter','latex');
        ylim([-pi pi]);
    end
end