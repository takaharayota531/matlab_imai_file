function show_4D_all(v,x,y,z,f,cmap)

length = size(v,4);
[X,Y,Z] = meshgrid(x,y,z);

fig = uifigure('Position',[500 400 560 560]);
axes = uiaxes(fig,'Position',[0 70 560 490]);
pnl = uipanel(fig,'Position',[0 0 560 70]);
sld = uislider(pnl,...
    'Position',[25 50 200 3]);
sld.ValueChangedFcn = @(sld,event) sliderMoving(sld,v,axes,X,Y,Z);
h = slice(axes,x,y,z,v(:,:,:,1),[],[],z,'nearest');
set(h,'edgecolor','none','FaceAlpha',0.1);
colormap(axes,cmap);
colorbar(axes);
caxis(axes,[min(v,[],'all') max(v,[],'all')]);
axes.YLim = [min(x) max(x)];
axes.XLim = [min(y) max(y)];
axes.ZLim = [min(z) max(z)];
axes.ZDir = 'reverse';
sld.Limits = [1 length];

end

function sliderMoving(sld,v,axes,x,y,z)
h = slice(axes,x,y,z,v(:,:,:,round(sld.Value)),[],[],z,'nearest');
set(h,'edgecolor','none','FaceAlpha',0.1);
colorbar(axes);
end