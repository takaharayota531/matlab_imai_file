% 

function sigma = calk_sigma(k)

row_num = size(k,1); %��
col_num = size(k,2); %�c

k_dim = size(k,4);
k_st = reshape(squeeze(k(1,1,1,:)),1,k_dim); % �ŏI�I�Ɋϑ��_��(289)�~k�̎�����(14)�ɂȂ�B
for y = 2:col_num
    k_st = [k_st;reshape(squeeze(k(1,y,1,:)),1,k_dim)];
end    
for x = 2:row_num
    for y = 1:col_num
        k_st = [k_st;reshape(squeeze(k(x,y,1,:)),1,k_dim)];
    end
end
% size(k_st) 
sigma = cov(k_st); %k�̊e�v�f�ɂ��ĕ��U�����U�s��̌v�Z