% 3次元配列の非零成分を散布図にする関数

function volume_plot(v)
[Nx,Ny,Nz] = size(v);
index = find(v>0);
index_x = 5e-3*(rem(index,Nx)+1);
index_y = 5e-3*(rem(floor((index-1)/Nx),Ny)+1);
index_z = 0.29 + 0.11/Nz*(rem(floor((index-1)/(Nx*Ny)),Nz)+1);
figure;
scatter3(index_x,index_y,index_z)
xlabel("x"); xlim([0 0.25]);
ylabel("y"); ylim([0 0.25]);
zlabel("z"); zlim([0.29 0.40]);
ax = gca;ax.ZDir = 'reverse';
end