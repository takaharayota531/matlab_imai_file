function [w,c] = SOM_linear(S,w,loop,alpha,beta)
tic % 学習にかかる時間を表示
w_points = size(w,2);
kxyz = size(S(:,:,:,1));
c = zeros(kxyz(1),kxyz(2),kxyz(3));

v1 = VideoWriter('figures\class_linear.avi');
v2 = VideoWriter('figures\w_linear.avi');
v1.FrameRate = 1;
v2.FrameRate = 1;
open(v1);
open(v2);
show_w(w);
writeVideo(v2,getframe(gcf));
close;
for t = 1:loop
        alpha = alpha*(loop-t)/loop;
        beta = beta*(loop-t)/loop;
    
    % 学習を行う
    for som_x = 1:kxyz(1)
        for som_y = 1:kxyz(2)
            for som_z = 1:kxyz(3)
                k_temp(:,1) = S(som_x,som_y,som_z,:);
%                 min = sum(abs(k_temp-w(:,1)));
                min = norm(k_temp-w(:,1));
                c(som_x,som_y,som_z) = 1;
                %勝者クラスを探す
                for n = 2:w_points
%                     temp = sum(abs(k_temp-w(:,n)));
                    temp = norm(k_temp-w(:,n));
                    if min > temp
                        min = temp;
                        c(som_x,som_y,som_z) = n;
                    end
                end
                
                
                w(:,c(som_x,som_y,som_z)) = w(:,c(som_x,som_y,som_z)) + alpha * (k_temp(:,1) - w(:,c(som_x,som_y,som_z))); % αによる更新
                
                switch c(som_x,som_y,som_z)  %βによる更新
                    case w_points  %クラスw_points(端)のとなりのクラスは'1'と'(w_points-1)'
                        w(:,(c(som_x,som_y,som_z) - 1)) = w(:,(c(som_x,som_y,som_z) - 1)) + beta * (k_temp(:,1) - w(:,(c(som_x,som_y,som_z) - 1)));
                        w(:,1) = w(:,1) + beta *  (k_temp(:,1) - w(:,1));
                        
                    case 1  %クラス1(端)のとなりのクラスは'2'と'w_points'
                        w(:,(c(som_x,som_y,som_z) + 1)) = w(:,(c(som_x,som_y,som_z) + 1)) + beta * (k_temp(:,1) - w(:,(c(som_x,som_y,som_z) + 1)));
                        w(:,w_points) = w(:,w_points) + beta * (k_temp(:,1) - w(:,w_points));
                        
                    otherwise
                        w(:,(c(som_x,som_y,som_z) - 1)) = w(:,(c(som_x,som_y,som_z) - 1)) + beta * (k_temp(:,1) - w(:,(c(som_x,som_y,som_z) - 1)));
                        w(:,(c(som_x,som_y,som_z) + 1)) = w(:,(c(som_x,som_y,som_z) + 1)) + beta * (k_temp(:,1) - w(:,(c(som_x,som_y,som_z) + 1)));
                end
            end
        end
    end
    
    disp(strcat(num2str(round(t/loop*100)),'% of learning was finished'));
    show_all_class(c,w_points);
    writeVideo(v1,getframe(gcf));
    close;
    show_w(w);
    writeVideo(v2,getframe(gcf));
    close;
    %     som_cdata = whiter(c, hsv(w_points), 1, w_points, peak_point);
    
    %figure(100);imagesc(x,z*100,som_cdata);colormap(hsv(w_points));colorbar
    %xlabel('Position X (cm)');ylabel('Distance from antenna (cm)');ylim([CUT_DISTANCE1 CUT_DISTANCE2]);caxis([0 w_points])
    %mov(t) = getframe(100);
end
close(v1);
close(v2);
toc