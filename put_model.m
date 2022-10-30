function put_model(h,model)
model = model==1;
l = 1;
m = size(model,1);
r = (m-1)/2;
[Nx,Ny] = size(h);
gap = floor((m+l-2)/2);
h = circshift(h,[gap gap]);
h_p = zeros(Nx,Ny);
for x = 1:Nx
    for y = 1:Ny
        h_p(rem((x-r-1:x+r-1)+Nx,Nx)+1,rem((y-r-1:y+r-1)+Ny,Ny)+1) = h_p(rem((x-r-1:x+r-1)+Nx,Nx)+1,rem((y-r-1:y+r-1)+Ny,Ny)+1)...
            + h(x,y)*model;
    end
end
fontsize = 12;
[Nx,Ny] = size(h);
m = size(model);
figure;
im = imagesc(h_p);
im.Parent.FontSize = fontsize;
colorbar('Fontsize',fontsize);
colormap(gray);
xlabel('Position $x$','Fontsize',fontsize,'FontName','SansSerif','Interpreter','latex');
ylabel('Position $y$','Fontsize',fontsize,'FontName','SansSerif','Interpreter','latex');
end