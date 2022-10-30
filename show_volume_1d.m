function show_volume_1d(v,x,y,z,cmap,dir)

v = permute(v,[2 1 3]);
[X,Y,Z] = meshgrid(x,y,z);
X = x;
Y = y;
Z = z;
length = size(v,dir);

fig = uifigure('Position',[500 400 560 560]);
axes = uiaxes(fig,'Position',[0 70 560 490]);
pnl = uipanel(fig,'Position',[0 0 560 70]);
switch dir
    case 1
        sld_axes = x;
    case 2
        sld_axes = y;
    case 3
        sld_axes = z;
    otherwise
        disp('"dir" has incorrect')
end
sld = uislider(pnl,...
    'Position',[25 50 500 3],...
    'ValueChangingFcn',@(sld,event) sliderMoving(event,v,axes,X,Y,Z,dir,sld_axes));
switch dir
    case 1
h = slice(axes,X,Y,Z,v,x(1),[],[]);
    case 2
h = slice(axes,X,Y,Z,v,[],y(1),[]);
    case 3
h = slice(axes,X,Y,Z,v,[],[],z(1));
    otherwise
        disp('"dir" has incorrect');
end
set(h,'edgecolor','none');
colormap(axes,cmap);
colorbar(axes);
caxis(axes,[min(v,[],'all') max(v,[],'all')]);
% caxis(axes,[-15 max(v,[],'all')]);
axes.YLim = [min(x) max(x)];
axes.XLim = [min(y) max(y)];
axes.ZLim = [min(z) max(z)];
axes.ZDir = 'reverse';
sld.Limits = [1 length];

end

function sliderMoving(event,v,axes,X,Y,Z,dir,sld_axes)
switch dir
    case 1
h = slice(axes,X,Y,Z,v,sld_axes(round(event.Value)),[],[]);
    case 2
h = slice(axes,X,Y,Z,v,[],sld_axes(round(event.Value)),[]);
    case 3
h = slice(axes,X,Y,Z,v,[],[],sld_axes(round(event.Value)));
    otherwise
        disp('"dir" has incorrect');
end
set(h,'edgecolor','none');
colorbar(axes);
end
