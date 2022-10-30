function [w,c] = SOM_batch_2D(S,w_points,loop,alpha,beta)
tic % 学習にかかる時間を表示
[N_x,N_y,N_z,N_k] = size(S);
S = permute(S,[1 2 4 3]);
w = zeros(N_k,w_points,N_z);
for z = 1: N_z
    w(:,:,z) = w_init(S(:,:,:,z),w_points);
end
c = zeros(N_x,N_y,N_z);

fig1 = figure;

v1 = VideoWriter('figures\class_batch_2D.avi');
v1.FrameRate = 3;
open(v1);

for t = 1:loop
%     alpha = alpha*(loop-t)/loop;
%     beta = beta*(loop-t)/loop;
    for z = 1:N_z
    % 学習を行う
    min = vecnorm(S(:,:,:,z)-reshape(w(:,1,z),[1 1 N_k]),2,3);
    c(:,:,z) = 1;
    %勝者クラスを探す
    for n = 2:w_points
        temp = vecnorm(S(:,:,:,z)-reshape(w(:,n,z),[1 1 N_k]),2,3);
        index = find(min>temp);
        min(index) = temp(index);
        c(index+N_x*N_y*(z-1)) = n;
    end
    
    for ic = 1:w_points
        if sum(c(:,:,z)==ic,'all') ~= 0 % 少なくともそのクラスに１つの要素が分類されている
            k_temp(:,1) = sum(S(:,:,:,z).*(c(:,:,z)==ic),[1 2])/sum(c(:,:,z)==ic,'all'); % クラスic に含まれるベクトルの平均
            w(:,ic,z) = w(:,ic,z) + alpha * (k_temp(:,1) - w(:,ic,z)); % αによる更新
            
            switch ic  %βによる更新
                case w_points  %クラスw_points(端)のとなりのクラスは'1'と'(w_points-1)'
                    w(:,(ic - 1),z) = w(:,(ic - 1),z) + beta * (k_temp(:,1) - w(:,(ic - 1),z));
                    w(:,1,z) = w(:,1,z) + beta *  (k_temp(:,1) - w(:,1,z));
                    
                case 1  %クラス1(端)のとなりのクラスは'2'と'w_points'
                    w(:,(ic + 1),z) = w(:,(ic + 1),z) + beta * (k_temp(:,1) - w(:,(ic + 1),z));
                    w(:,w_points,z) = w(:,w_points,z) + beta * (k_temp(:,1) - w(:,w_points,z));
                    
                otherwise
                    w(:,(ic - 1),z) = w(:,(ic - 1),z) + beta * (k_temp(:,1) - w(:,(ic - 1),z));
                    w(:,(ic + 1),z) = w(:,(ic + 1),z) + beta * (k_temp(:,1) - w(:,(ic + 1),z));
            end
        end
    end
    end
%     disp(strcat(num2str(round(t/loop*100)),'% of learning was finished'))
    show_all_depth(c,hsv(8),fig1);
    writeVideo(v1,getframe(fig1));
end
close(fig1);
close(v1);
toc