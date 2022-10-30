function make_movie(k,model)
[Nx,Ny,k_dim] = size(k);
m = size(model,1);
t=0;
v = VideoWriter('figure\model_movie.avi');
open(v);
for x = 1:Nx-m+1
    for y = 1:Ny-m+1
        t=t+1;
        ft = zeros(Nx,Ny);
        ft(rem(x-1:x+m-2,Nx)+1,rem(y-1:y+m-2,Ny)+1) = (model==1);
        imagesc(ft); colorbar; colormap(gray);
        frame = getframe(gcf);
        writeVideo(v,frame);
    end
end
close(v);