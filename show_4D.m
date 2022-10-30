function show_4D(v,x,y,z,f,cmap,dir)

length1 = size(v,dir);
length2 = size(f,2);
[X,Y,Z] = meshgrid(x,y,z);

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
sld1 = uislider(pnl,...
    'Position',[25 50 200 3]);
sld2 = uislider(pnl,...
    'Position',[250 50 200 3]);
sld1.ValueChangedFcn = @(sld1,event) sliderMoving(sld1,sld2,v,axes,X,Y,Z,dir,sld_axes);
sld2.ValueChangedFcn = @(sld2,event) sliderMoving(sld1,sld2,v,axes,X,Y,Z,dir,sld_axes);

switch dir
    case 1
h = slice(axes,X,Y,Z,v(:,:,:,1),x(1),[],[]);
    case 2
h = slice(axes,X,Y,Z,v(:,:,:,1),[],y(1),[]);
    case 3
h = slice(axes,X,Y,Z,squeeze(v(:,:,:,1)),[],[],z(1));
    otherwise
        disp('"dir" has incorrect');
end
set(h,'edgecolor','none');
colormap(axes,cmap);
colorbar(axes);
caxis(axes,[min(v,[],'all') max(v,[],'all')]);
axes.YLim = [min(x) max(x)];
axes.XLim = [min(y) max(y)];
axes.ZLim = [min(z) max(z)];
axes.ZDir = 'reverse';
sld1.Limits = [1 length1];
sld2.Limits = [1 length2];

end

function sliderMoving(sld1,sld2,v,axes,X,Y,Z,dir,sld_axes)
switch dir
    case 1
h = slice(axes,X,Y,Z,v(:,:,:,round(sld2.Value)),sld_axes(round(sld1.Value)),[],[]);
    case 2
h = slice(axes,X,Y,Z,v(:,:,:,round(sld2.Value)),[],sld_axes(round(sld1.Value)),[]);
    case 3
h = slice(axes,X,Y,Z,v(:,:,:,round(sld2.Value)),[],[],sld_axes(round(sld1.Value)));
    otherwise
        disp('"dir" has incorrect');
end
set(h,'edgecolor','none');
colorbar(axes);
end