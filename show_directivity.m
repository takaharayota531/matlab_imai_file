function show_directivity(d)

length = size(d,2);
rmax = max(d,[],'all');
rmin = min(d,[],'all');
x = 0:360;

%clear struct and prepare blank figure
fig = uifigure('Position',[500 100 560 700]);
axes = uiaxes(fig,'Position',[0 200 560 490]);
pnl = uipanel(fig,'Position',[0 0 560 200]);
%create polaraxes objects and store handles
plot(axes,x,d(:,1));
ylim(axes,[rmin rmax]);
%create a button that plots random data
sld = uislider(pnl,...
    'Position',[25 50 300 3],...
    'ValueChangingFcn',@(sld,event) sliderMoving(event,x,d,axes,rmin,rmax));
sld.Limits = [1 length];
end

function sliderMoving(event,x,v,axes,rmin,rmax)
plot(axes,x,v(:,ceil(event.Value)));
ylim(axes,[rmin rmax]);
end
