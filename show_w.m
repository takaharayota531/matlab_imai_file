function show_w(w,fig)
figure(fig);

data_max = max(abs(w),[],'all');
data_min = min(abs(w),[],'all');

row = 1; % subplot行数
col = 2; % subplot列数

figure_size = [ 0, 200, 1000, 1000/col*1.2*row];
set(fig, 'Position', figure_size);

ax1 = subplot(1,2,1);
imagesc(abs(w),[data_min data_max]);
        colormap(ax1,parula(4096));
        colorbar(ax1);
ax2 = subplot(1,2,2);
imagesc(angle(w),[-pi pi]);
        colormap(ax2,hsv(4096));
        colorbar(ax2);
