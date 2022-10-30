function show_volume_all(v,x,y,z,cmap)

length = size(v);
v = permute(v,[2 1 3]);

figure;
ax = axes(gcf);
h = slice(ax,x,y,z,v,[],[],z,'nearest');
set(h,'edgecolor','none','FaceAlpha',0.2);
colormap(ax,cmap);
colorbar(ax);
caxis(ax,[min(v,[],'all') max(v,[],'all')]);
% caxis([-15 max(v,[],'all')]);
ax.XLim = [min(x) max(x)];
ax.YLim = [min(y) max(y)];
ax.ZLim = [min(z) max(z)];
ax.ZDir = 'reverse';
xlabel(ax,'$x$');
ylabel(ax,'$y$');
zlabel(ax,'$z$');

end