%Function M-file:classify2.m
%classify���s��
%
%
%

function [c_out,w] = classify2(k,w,w_points,loop,alpha,beta,sigma)
% writerObj = VideoWriter('..\..\SOM.avi');
% writerObj.FrameRate = 3;
% open(writerObj);

if k < eps
    disp('���̓f�[�^���s�\���ł��iclassify2.m�j')
end

kxy = size(k,1,2); % k�̋�ԕ����͈̔�(17*17)
c = zeros(kxy(1),kxy(2)); % �e���W�ł�k�̃N���X�������ʂ̊i�[�z��

m=1; %path_all
% inv_sigma = inv(sigma); % ���U�����U�s��̋t�s��
% inv_sigma = sigma; % ??
for t = 1:loop
    
    alpha = alpha * (loop - t) / loop; % �Q�ƃx�N�g���̍X�V�������X�Ɍ���
    beta = beta * (loop - t) / loop;
% 
    for x = 1:kxy(1)
%     for tt = 1:loop
        for y = 1:kxy(2)
%             x = randi(kxy(1));
%             y = randi(kxy(2));
            k_temp1(1,:) = k(x,y,:);
            k_temp2 = k_temp1.'; % �������Ƃ�Ȃ��z��]�u
            max = nansum(abs(k_temp2(:,1)).*abs(w(:,1)).*exp(1i*(angle(w(:,1))-angle(k_temp2(:,1))))) / (norm(k_temp2(:,1))*norm(w(:,1)));% ���f����/���f�x�N�g���̐�Βl(�m����)
% sigma�ɂ��d�݂Â�����
%             max = abs(k_temp2(:,1)'*inv_sigma*w(:,1)) / (norm(k_temp2(:,1)'*inv_sigma)*norm(w(:,1)));
%             max = abs(k_temp1(1,:)*inv_sigma*conj(w(:,1))) / (norm(k_temp1(1,:)*inv_sigma)*norm(w(:,1)));

%             min = nansum(abs(k_temp2(:,1) - w(:,1) ));% ���[�N���b�h����

            c(x,y) = 1;

            for n = 1:w_points % �e�Q�ƃx�N�g���ɑ΂��ē����ʃx�N�g���̋߂����r
%>>>>
                temp = nansum(abs(k_temp2(:,1)).*abs(w(:,n)).*exp(1i * (angle(w(:,n)) - angle(k_temp2(:,1))) )) / (norm(k_temp2(:,1))*norm(w(:,n)));% ���f����/���f�x�N�g���̐�Βl(�m����)
%                 temp = abs((k_temp2(:,1)'*inv_sigma*w(:,n))) / (norm(k_temp2(:,1)'*inv_sigma)*norm(w(:,n)));
%                 temp = abs((k_temp1(1,:)*inv_sigma*conj(w(:,n)))) / (norm(k_temp1(1,:)*inv_sigma)*norm(w(:,n)));
                if max < temp % ���f���ς����傫���ꍇ���̎Q�ƃN���X�����̍��W�̃N���X�Ƃ���
                    max = temp;
%----
%                 temp = nansum(abs(k_temp2(:,1) - w(:,n)));% ��
% %                 temp = abs((k_temp2(:,1) - w(:,n))'*inv_sigma*(k_temp2(:,1) - w(:,n)));
%                 if min > temp
%                     min = temp;
%<<<<
                    c(x,y) = n;
                end
            end
            
            w(:,c(x, y)) = w(:, c(x,y)) + alpha * (k_temp2(:,1) - w(:,c(x, y)));%�Q�ƃx�N�g���̍X�V

            switch c(x,y) % �O��̃N���X�̎Q�ƃx�N�g�����X�V
                case w_points
                    w(:,(c(x,y) - 1)) = w(:,(c(x,y) - 1)) + beta * (k_temp2(:,1) - w(:,(c(x,y) - 1))); %beta�ɂ��X�V
                    w(:,1) = w(:,1) + beta *  (k_temp2(:,1) - w(:,1));

                case 1
                    w(:,(c(x,y) + 1)) = w(:,(c(x,y) + 1)) + beta * (k_temp2(:,1) - w(:,(c(x,y) + 1))); %beta�ɂ��X�V
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
c_out = c(:,:); % �o�͂���N���X��������
%figure;
%imagesc(c_out(:,:));
%colormap(hsv(10));
%colorbar;



%end of file