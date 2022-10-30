function show_all_slices(v,x,y,z,cmap)
figure;
ax = axes;
[X,Y,Z] = meshgrid(x,y,z);
h = slice(ax,X,Y,Z,v,[],[],z);
caxis([min(v,[],'all') max(v,[],'all')]);
ax.XLim = [min(x) max(x)];
ax.YLim = [min(y) max(y)];
ax.ZLim = [min(z) max(z)];
ax.ZDir = 'reverse';
set(h,'edgecolor','none');
colormap(cmap);
xlabel('$x$','FontName','SansSerif','Interpreter','latex');
ylabel('$y$','FontName','SansSerif','Interpreter','latex');
zlabel('$z$','FontName','SansSerif','Interpreter','latex');
c = colorbar;
c.Label.String = 'Amplitude';