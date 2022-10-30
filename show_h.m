function show_h(h)
fontsize = 12;
[Nx,Ny] = size(h);
figure;
im = imagesc(h);
im.Parent.FontSize = fontsize;
c = colorbar('Fontsize',fontsize);
c.Label.String = '$h$';
c.Label.FontSize = fontsize;
c.Label.FontName = 'SansSerif';
c.Label.Interpreter = 'latex';
xlabel('Position $x$','Fontsize',fontsize,'FontName','SansSerif','Interpreter','latex');
ylabel('Position $y$','Fontsize',fontsize,'FontName','SansSerif','Interpreter','latex');
end