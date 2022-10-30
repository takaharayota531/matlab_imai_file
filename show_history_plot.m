function show_history_plot(x,h)

length = size(h,2);

fig = uifigure('Position',[500 400 560 560]);
axes = uiaxes(fig,'Position',[0 70 560 490]);
pnl = uipanel(fig,'Position',[0 0 560 70]);
sld = uislider(pnl,...
    'Position',[25 50 150 3],...
    'ValueChangingFcn',@(sld,event) sliderMoving(event,x,h,axes));
plot(x,h(:,1),'Parent',axes);

sld.Limits = [1 length];

end

function sliderMoving(event,x,h,axes)
plot(x,h(:,round(event.Value)),'Parent',axes);
colorbar(axes);
end