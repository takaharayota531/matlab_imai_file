function show_directivity_radar(d)

length = size(d,2);
rmax = max(d,[],'all');
rmin = min(d,[],'all');

%clear struct and prepare blank figure
h=struct;h.f=uifigure(1);clf(h.f)
%create polaraxes objects and store handles
pos_vec=[0.1 0.1 0.9 0.9];
h.pAxis = polaraxes(...
        'Parent',h.f,...
        'Units','Normalized',...
        'Position',pos_vec);
rlim(h.pAxis,[rmin-10 rmax+10]);
% for n=1:numel(pos_vec)
%     h.pAxis=polaraxes(...
%         'Parent',h.f,...
%         'Units','Normalized',...
%         'Position',pos_vec{n});
% end
%create a button that plots random data
h.slider = uislider(h.f,...
    'Position',[25 50 300 3],...
    'ValueChangingFcn',@(sld,event) sliderMoving(event,d,h.pAxis,rmin,rmax));
%h.runbutton=uicontrol(...
%     'Parent',h.f,...
%         'Units','Normalized',...
%         'Position',[0 0 1 0.05],...
%         'String','Click me!',...
%         'Callback',@PlotSomeStuff);
guidata(h.f,h)
end

function sliderMoving(event,v,axes,rmin,rmax)
polarplot(axes,v(2:end,ceil(event.Value)));
rlim(axes,[rmin rmax]);
end

function PlotSomeStuff(hObject,eventdata)
%plot random data in each polaraxes
h=guidata(hObject);
for n=1:numel(h.pAxis)
    rho=rand(1,20);
    theta_noise=(rand(size(rho))-0.5)/10;
    theta=linspace(0,2*pi,numel(rho))+theta_noise;
    polarplot(h.pAxis{n},theta,rho)
end
end