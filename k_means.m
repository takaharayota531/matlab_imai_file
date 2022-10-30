function [w,c] = k_means(S,w_points,loop)
tic % 学習にかかる時間を表示
w = w_init(S,w_points);
kxyz = size(S);
c = zeros(kxyz(1),kxyz(2),kxyz(3));

fig1 = figure;
fig2 = figure;

v1 = VideoWriter('figures\class_batch.avi');
v2 = VideoWriter('figures\w_batch.avi');
v1.FrameRate = 3;
v2.FrameRate = 3;
open(v1);
open(v2);
show_w(w,fig2);
writeVideo(v2,getframe(gcf));
for t = 1:loop
%     alpha = alpha*(loop-t)/loop;
%     beta = beta*(loop-t)/loop;
    
    % 学習を行う
    min = vecnorm(S-reshape(w(:,1),[1 1 1 kxyz(4)]),2,4); % ユークリッド距離
%     min = sum(S.*reshape(conj(w(:,1)),[1 1 1 kxyz(4)]),4)./vecnorm(S,2,4).*norm(w(:,1)); % 偏角
    c(:,:,:) = 1;
    %勝者クラスを探す
    for n = 2:w_points
        temp = vecnorm(S-reshape(w(:,n),[1 1 1 kxyz(4)]),2,4); % ユークリッド距離
%         temp = sum(S.*reshape(conj(w(:,n)),[1 1 1 kxyz(4)]),4)./vecnorm(S,2,4).*norm(w(:,n)); % 偏角
        index = find(min>temp);
        min(index) = temp(index);
        c(index) = n;
    end

    for n = 1:w_points
        if sum(c==n,'all')~=0
            w(:,n) = sum(c==n.*S,[1 2 3])/sum(c==n,'all');
        end
    end

    show_all_class(c,w_points,fig1);
    writeVideo(v1,getframe(fig1));
    show_w(w,fig2);
    writeVideo(v2,getframe(fig2));
    
    %figure(100);imagesc(x,z*100,som_cdata);colormap(hsv(w_points));colorbar
    %xlabel('Position X (cm)');ylabel('Distance from antenna (cm)');ylim([CUT_DISTANCE1 CUT_DISTANCE2]);caxis([0 w_points])
    %mov(t) = getframe(100);
end
close([fig1 fig2]);
close(v1);
close(v2);
toc