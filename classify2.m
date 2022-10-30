%Function M-file:classify2.m
%classifyを行う
%
%
%

function [c_out,w] = classify2(k,w,w_points,loop,alpha,beta,sigma)
% writerObj = VideoWriter('..\..\SOM.avi');
% writerObj.FrameRate = 3;
% open(writerObj);

if k < eps
    disp('入力データが不十分です（classify2.m）')
end

kxy = size(k,1,2); % kの空間方向の範囲(17*17)
c = zeros(kxy(1),kxy(2)); % 各座標でのkのクラス分け結果の格納配列

m=1; %path_all
% inv_sigma = inv(sigma); % 分散共分散行列の逆行列
% inv_sigma = sigma; % ??
for t = 1:loop
    
    alpha = alpha * (loop - t) / loop; % 参照ベクトルの更新幅が徐々に減少
    beta = beta * (loop - t) / loop;
% 
    for x = 1:kxy(1)
%     for tt = 1:loop
        for y = 1:kxy(2)
%             x = randi(kxy(1));
%             y = randi(kxy(2));
            k_temp1(1,:) = k(x,y,:);
            k_temp2 = k_temp1.'; % 共役をとらない配列転置
            max = nansum(abs(k_temp2(:,1)).*abs(w(:,1)).*exp(1i*(angle(w(:,1))-angle(k_temp2(:,1))))) / (norm(k_temp2(:,1))*norm(w(:,1)));% 複素内積/複素ベクトルの絶対値(ノルム)
% sigmaによる重みづけあり
%             max = abs(k_temp2(:,1)'*inv_sigma*w(:,1)) / (norm(k_temp2(:,1)'*inv_sigma)*norm(w(:,1)));
%             max = abs(k_temp1(1,:)*inv_sigma*conj(w(:,1))) / (norm(k_temp1(1,:)*inv_sigma)*norm(w(:,1)));

%             min = nansum(abs(k_temp2(:,1) - w(:,1) ));% ユークリッド距離

            c(x,y) = 1;

            for n = 1:w_points % 各参照ベクトルに対して特徴量ベクトルの近さを比較
%>>>>
                temp = nansum(abs(k_temp2(:,1)).*abs(w(:,n)).*exp(1i * (angle(w(:,n)) - angle(k_temp2(:,1))) )) / (norm(k_temp2(:,1))*norm(w(:,n)));% 複素内積/複素ベクトルの絶対値(ノルム)
%                 temp = abs((k_temp2(:,1)'*inv_sigma*w(:,n))) / (norm(k_temp2(:,1)'*inv_sigma)*norm(w(:,n)));
%                 temp = abs((k_temp1(1,:)*inv_sigma*conj(w(:,n)))) / (norm(k_temp1(1,:)*inv_sigma)*norm(w(:,n)));
                if max < temp % 複素内積がより大きい場合この参照クラスをこの座標のクラスとする
                    max = temp;
%----
%                 temp = nansum(abs(k_temp2(:,1) - w(:,n)));% ユ
% %                 temp = abs((k_temp2(:,1) - w(:,n))'*inv_sigma*(k_temp2(:,1) - w(:,n)));
%                 if min > temp
%                     min = temp;
%<<<<
                    c(x,y) = n;
                end
            end
            
            w(:,c(x, y)) = w(:, c(x,y)) + alpha * (k_temp2(:,1) - w(:,c(x, y)));%参照ベクトルの更新

            switch c(x,y) % 前後のクラスの参照ベクトルを更新
                case w_points
                    w(:,(c(x,y) - 1)) = w(:,(c(x,y) - 1)) + beta * (k_temp2(:,1) - w(:,(c(x,y) - 1))); %betaによる更新
                    w(:,1) = w(:,1) + beta *  (k_temp2(:,1) - w(:,1));

                case 1
                    w(:,(c(x,y) + 1)) = w(:,(c(x,y) + 1)) + beta * (k_temp2(:,1) - w(:,(c(x,y) + 1))); %betaによる更新
                    w(:,w_points) = w(:,w_points) + beta * (k_temp2(:,1) - w(:,w_points));

                otherwise
                    w(:,(c(x,y) - 1)) = w(:,(c(x,y) - 1)) + beta * (k_temp2(:,1) - w(:,(c(x,y) - 1)));  
                    w(:,(c(x,y) + 1)) = w(:,(c(x,y) + 1)) + beta * (k_temp2(:,1) - w(:,(c(x,y) + 1)));

            end
        end
    end
%     if t < 50
%         figure(t); imagesc(c(:,:).'); caxis([1 w_points]);colormap(hsv(w_points)); colorbar;
%         M = getframe(t);
%         writeVideo(writerObj, M);
%     end
end

% close(writerObj);
%c_out = zeros(kxy(2),kxy(1));
% c_out = c(:,:).';% / w_points;
c_out = c(:,:); % 出力するクラス分け結果
%figure;
%imagesc(c_out(:,:));
%colormap(hsv(10));
%colorbar;



%end of file