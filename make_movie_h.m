function make_movie_h(h,model)
[Nx,Ny,T] = size(h);
m = size(model,1);
gap = floor((m-1)/2);
h = circshift(h,[gap gap 0]);
colorbar('Fontsize',20);
v = VideoWriter('figures\h_movie.avi');
v.FrameRate = 3;
open(v);
for t = 1:T
    ti = horzcat('Step',num2str(t-1,'%d'));
    imagesc(h(:,:,t)); colorbar('Fontsize',20); title(ti,'Fontsize',20);
        frame = getframe(gcf);
        writeVideo(v,frame);
end
close(v);