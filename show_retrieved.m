function show_retrieved(K,f,z)
[Nx,Ny,Nz,Nf] = size(K);
N = Nx*Ny*Nz;
Nh = Nx*Ny;
z = reshape(repmat(reshape(z,1,[]),Nh,1),1,[]);
K = reshape(K,[Nx*Ny*Nz, Nf]).';
col = 1;
row = 2;
left_m = 0.08; % 左側余白の割合
bot_m = 0.1; % 下側余白の割合
ver_r = 1.3; % 縦方向余裕 (値が大きいほど各axes間の余白が大きくなる)
col_r = 1.05; % 横方向余裕 (値が大きいほど各axes間の余白が大きくなる)

figure_size = [ 0, 30, 1900, 950];
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
        imagesc(z,f,abs(K));
        c1 = colorbar;colormap(ax(n),jet);
        c1.Label.String = 'Amplitude';
        xlabel('depth[m]','FontName','SansSerif','Interpreter','latex');
        ylabel('Frequency[Hz]','FontName','SansSerif','Interpreter','latex');
    else
        imagesc(z,f,angle(K));
        c2 = colorbar;colormap(ax(n),hsv);
        c2.Label.String = 'Phase[rad]';
        xlabel('depth[m]','FontName','SansSerif','Interpreter','latex');
        ylabel('Frequency[Hz]','FontName','SansSerif','Interpreter','latex');
    end
end