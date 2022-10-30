% xystage�g�p�̃f�[�^����f�[�^���z������ŕ��f���ˌW�����o��
% xystage���Q�b�g�����f�[�^�͒����ɑ��肵�����́iliner_measure.vi��z��j

close all;
clear;
set(0, 'defaultAxesFontName', 'Arial');
set(0, 'defaultTextFontName', 'Arial');
set(0, 'DefaultAxesFontSize', 12);
set(0, 'DefaultTextFontSize', 12);
set(0, 'DefaultAxesLineWidth', 1);
set(0, 'DefaultFigureColor', 'w');

%% �p�����[�^�̐ݒ�

% ����p�����[�^�[
START_FREQ = 1; % ����J�n���g���iGHz�j
STOP_FREQ = 21; % ����I�����g���iGHz�j
FREQ_POINT = 401; %���g���̃|�C���g��(8GHz������100�_)
SCALE_X = 60; % XY�X�e�[�W��X�����֓���������
SCALE_Y = SCALE_X;
DX = 0.5; % XY�X�e�[�W�ň�񂠂����X�����֓��������icm�j
rawdata = ''20210727mine'.txt'; % �ǂݍ��ރe�L�X�g�t�@�C����



% ��̓p�����[�^�[
CUT_DISTANCE1 = 40; % ��͔͈͂̉����l�icm�j
CUT_DISTANCE2 = 70; % ��͔͈͂̏���l�icm�j
DISP_ABOVE = 40; % �\���͈͂̉����l�icm�j
DISP_BELOW = 100; % �\���͈͂̏���l�icm�j
N_IFFT = 2^10; % IFFT��
ITERATION = 5; % �ő�l��T����Ƃ�����J��Ԃ���
DISP_X = 3; % �ǂ̏ꏊ��S21��\�����邩X���ł̈ʒu���w��icm�j
DISP_Y = 58; % �ǂ̏ꏊ��S21��\�����邩Y���ł̈ʒu���w��icm�j
S = 0.1; % �񍀕��z�̕��U
VIEW_DZ = 0.1; % �ʑ��摜��\������ۂ̈�̃s�[�N�̕��icm�j
if DISP_X < 1 || DISP_X > SCALE_X % disp_f��������g���ɓ����Ă��Ȃ��ꍇ�͌x��
    disp('�p�����[�^ disp_x ���������͈͂ɐݒ肳��Ă��܂���')
    return
end
if CUT_DISTANCE1 > CUT_DISTANCE2 % cut_distance�̑召���t�̏ꍇ�͌x��
    disp('�p�����[�^ cut_distance1 �� cut_distance2 �̑召���t�ł�')
    return
end


%% rowdata�̓ǂݍ��݂Ɗm�F

fprintf('Loading txt data \n\n');
rawdata = load(rawdata); % �v���f�[�^�ǂݎ��[index, frequency, amplitude, phase, x, y]

c = 1; % for���ŉ񂷗p�̐���
data = zeros(length(rawdata)*((FREQ_POINT-1)/FREQ_POINT),6); % rawdata�����Ȃ����z��
for n = 1:length(rawdata)
    if rawdata(n,1) ~= 0 % �e����|�C���g�ɂ����đ���o�O�̃|�C���g�����O
        data(c,:) = rawdata(n,:); % �V�����z��ɑ��
        c = c+1;
    end
end

S21 = zeros(SCALE_Y,SCALE_X,FREQ_POINT-1); % S21�i���f���j���i�[����z��
df = (STOP_FREQ-START_FREQ)/(FREQ_POINT-1); % ���g���ɂ����鑪��Ԋu�iGHz�j
f = (START_FREQ+df:df:STOP_FREQ)*10^9; % ���肵�����g���𕪊��iHz�j
df = df*10^9; % ����Ԋu��Hz�ɒ���

for x = 1:SCALE_X % �z���
    for y = 1:SCALE_Y
        finish_point = (FREQ_POINT-1)*((x-1)*SCALE_Y+y-1); % ���̍��W�̃f�[�^�͉��Ԗڂ���n�܂�̂�
        G = data(finish_point+1:finish_point+FREQ_POINT-1,3); % �U���𒊏o�ilog�`���j
        P = data(finish_point+1:finish_point+FREQ_POINT-1,4)/180*pi; % �ʑ��𒊏o
        S21(y,x,:) = 10.^(G/10).*exp(1i*P); % ���f���f�[�^�ɒ����Ċi�[
    end
end

disp_data = zeros(1,FREQ_POINT-1);
DISP_X = DISP_X/DX;
for k = 1:FREQ_POINT-1
    disp_data(k) = S21(DISP_X,DISP_X,k);
end


figure('Name','����ꏊ�ł�S21');subplot(2,1,1);plot(f/10^9,10*log10(abs(disp_data)),'b','linewidth', 2.0);xlim([START_FREQ STOP_FREQ]);
xlabel('Frequency (GHz)');ylabel('Signal power (dB)');set(gca, 'LooseInset', get(gca, 'TightInset'));
subplot(2,1,2);plot(f/10^9,angle(disp_data),'b','linewidth', 2.0);xlim([START_FREQ STOP_FREQ])
xlabel('Frequency (GHz)');ylabel('Phase (rad)');set(gca, 'LooseInset', get(gca, 'TightInset'));


%% �[�������֕ϊ�

peak_distance = zeros(SCALE_X, 1); % �s�[�N���������i�[���鏊
% complex_r = zeros(SCALE_X, 1); % �U���ő�|�C���g�̕��f���ˌW�����i�[

fprintf(strcat(num2str(N_IFFT),' points fourier transfer \n\n'))

onecircle_t = 1/df; % ���ԉ����ł̎���
t = 0:onecircle_t/N_IFFT:onecircle_t -onecircle_t/N_IFFT; % ���ԉ����̎�����N�_��������
c = 299792458; % �����im/s�j
z = t*c/2; % �A���e�i����̋����ɑΉ�������W�A�����������o�邩��2�Ŋ����ăA���e�i����̋����im�j
dz = z(2)-z(1); % �A���e�i����̋����z��̊Ԋu�im�j

% 40cm����70cm��؂藎�Ƃ�
cut_value1 = round(CUT_DISTANCE1/100/dz); % �؂藎�Ƃ������͗v�f�̉��Ԗڂ�
cut_value2 = round(CUT_DISTANCE2/100/dz); % 
cutfilter1 = zeros(1,cut_value1); % �؂藎�Ƃ�����
cutfilter2 = ones(1,cut_value2-cut_value1);
cutfilter3 = zeros(1,N_IFFT-cut_value2);
filter = horzcat(cutfilter1,cutfilter2,cutfilter3);

twoD_textual = zeros(SCALE_Y,SCALE_X,N_IFFT); % �t�[���G�ϊ���̋������i�[����z��
win = chebwin(FREQ_POINT-1);
phase_re = zeros(SCALE_Y,SCALE_X,FREQ_POINT-1);

for k = 1:SCALE_X
    for i = 1:SCALE_Y
        data = zeros(1,FREQ_POINT-1);
        for m = 1:FREQ_POINT-1
            data(m) = S21(i,k,m);
        end
        F = ifft(data,N_IFFT); % S21���t�t�[���G�ϊ�
        twoD_textual(i,k,:) = F.*filter; % �p���X�������w�苗���Ő؂���i�[
    end
end


x = DX:DX:DX*SCALE_X; % x���̐ݒ�
y = x;

disp_data = zeros(1,N_IFFT);
for m = 1:N_IFFT
    disp_data(m) = twoD_textual(DISP_X,DISP_X,m);
end

figure('Name','�p���X�����i�U���j');plot(z*100,abs(disp_data),'b','linewidth', 2.0);set(gca, 'LooseInset', get(gca, 'TightInset'));
xlabel('Distance from antenna (cm)');ylabel('Signal power (arb)');xlim([CUT_DISTANCE1 CUT_DISTANCE2]);
figure('Name','�p���X�����i�ʑ��j');plot(z*100,angle(disp_data),'b','linewidth', 2.0);set(gca, 'LooseInset', get(gca, 'TightInset'));
xlabel('Distance from antenna (cm)');ylabel('Phase (rad)');xlim([CUT_DISTANCE1 CUT_DISTANCE2]);

%% �ʑ������@


fprintf('Phase Retrieving ... \n\n')
peak_point = zeros(SCALE_Y,SCALE_X,N_IFFT);
peak_amplitude = zeros(SCALE_Y,SCALE_X,N_IFFT);
peak_phase = zeros(SCALE_Y,SCALE_X,N_IFFT);
peak_S21 = zeros(SCALE_Y,SCALE_X,N_IFFT,FREQ_POINT-1);
threshold = max(max(max(abs(twoD_textual))))*0.1;
VIEW_DZ = round(VIEW_DZ/100/dz/2);

for k = 1:SCALE_X
    for h = 1:SCALE_Y
        F = zeros(1,N_IFFT);
        for m = 1:N_IFFT
            F(m) = twoD_textual(h,k,m);
        end

        for i = 1:ITERATION
            M = abs(F); % �t�[���G�ϊ���̐U�����
            [peak_val, peak_pixel] = max(M); % �s�[�N����ԗ��ꏊ�̏��
            if peak_val > threshold
                peak_point(h,k,peak_pixel) = 1;
                peak_amplitude(h,k,peak_pixel) = peak_val;
                win_fun = gaussian(z,peak_pixel*dz,S); % �K�E�X�E�B���h�E�쐬
                F_gau = F.*win_fun; % data�ɃK�E�X�t�B���^�[��K�p
                F_shift = circshift(F_gau,-peak_pixel); % t=0(z=0)�ɃV�t�g
                complex_r = fft(F_shift,N_IFFT); % ���g���̈�ɕϊ�
                complex_r = complex_r(1:(FREQ_POINT-1));
                peak_S21(h,k,peak_pixel,:) = complex_r; 
                peak_phase(h,k,peak_pixel) = angle(mean(complex_r));
                F = F-F_gau;
            end
        end
    end
end

%% �ʑ�������̈ʑ��̗l�q

cdata = whiter(peak_phase, 'hsv', -pi, pi, peak_point);

figure('Name','�ʑ�������̈ʑ�');
for k = 1:SCALE_X
    for h = 1:SCALE_Y
        for m = 1:N_IFFT
            if peak_point(h,k,m) == 1
                x_init = (k-1)*DX;
                y_init = (h-1)*DX;
                z_init = m*dz*100;
                vert = [x_init y_init z_init;x_init+DX y_init z_init;x_init+DX y_init+DX z_init;x_init y_init+DX z_init;...
                    x_init y_init z_init+DX;x_init+DX y_init z_init+DX;x_init+DX y_init+DX z_init+DX;x_init y_init+DX z_init+DX];
                fac = [1 2 6 5;2 3 7 6;3 4 8 7;4 1 5 8;1 2 3 4;5 6 7 8];
                color = zeros(1,3);
                color(1) = cdata(h,k,m,1);
                color(2) = cdata(h,k,m,2);
                color(3) = cdata(h,k,m,3);
                color = repmat(color,8,1);
                patch('Vertices',vert,'Faces',fac,'FaceVertexCData',color,'FaceColor','flat')
                hold on
            end
        end
    end
end
zlabel('Distance from antenna (cm)');ylabel('Position Y (cm)');xlabel('Position X (cm)');zlim([CUT_DISTANCE1 CUT_DISTANCE2]);view(3)
colorbar;colormap hsv;set(gca,'ZDir','reverse');set(gca,'YDir','reverse');caxis([-pi pi])
hold off

%% SOM�̊w�K

peak_S21 = peak_S21/max(max(max(max(abs(peak_S21)))));
alpha = 0.2; beta = alpha/100; %��,���̒l
loop = 100; % �Q�ƃx�N�g���̍X�V��

w_points = 8; % �Q�ƃx�N�g���̐�
w_scale = max(max(max(max(abs(peak_S21))))); % �Q�ƃx�N�g���̍ő�l
k_dim = FREQ_POINT-1; % �Q�ƃx�N�g���̎����A���̏ꍇ�͎��g���|�C���g
w_in = w_init(w_points ,w_scale ,k_dim); % �Q�ƃx�N�g���̐����Ə�����

w = w_in; % �������Q�ƃx�N�g���̑��
kxy = size(peak_S21(:,:,1)); % �x�N�g����
c = zeros(kxy(1),kxy(2));
mov(1:loop) = struct('cdata', [], 'colormap', []);

tic % �w�K�ɂ����鎞�Ԃ�\��
for t = 1:loop
%     alpha = alpha*(loop-t)/loop;
%     beta = beta*(loop-t)/loop;
    
    % �w�K���s��
    for som_x = 1:kxy(2)
        for som_y = 1:kxy(1)
            k_temp(:,1) = peak_S21(som_y,som_x,:);
            if k_temp ~= zeros(FREQ_POINT-1,1)
                min = sum(abs(k_temp-w(:,1)));
%                 min = norm(k_temp-w(:,1));
                c(som_y,som_x) = 1;
                %���҃N���X��T��
                for n = 2:w_points
                    temp = sum(abs(k_temp-w(:,n)));
%                     temp = norm(k_temp-w(:,n));
                    if min > temp
                        min = temp;
                        c(som_y,som_x) = n;
                    end
                end
                

                w(:,c(som_y,som_x)) = w(:,c(som_y,som_x)) + alpha * (k_temp(:,1) - w(:,c(som_y,som_x))); % ���ɂ��X�V
            
                switch c(som_y,som_x)  %���ɂ��X�V
                    case w_points  %�N���Xw_points(�[)�̂ƂȂ�̃N���X��'1'��'(w_points-1)'
                        w(:,(c(som_y,som_x) - 1)) = w(:,(c(som_y,som_x) - 1)) + beta * (k_temp(:,1) - w(:,(c(som_y,som_x) - 1)));
                        w(:,1) = w(:,1) + beta *  (k_temp(:,1) - w(:,1));
                    
                    case 1  %�N���X1(�[)�̂ƂȂ�̃N���X��'2'��'w_points'
                        w(:,(c(som_y,som_x) + 1)) = w(:,(c(som_y,som_x) + 1)) + beta * (k_temp(:,1) - w(:,(c(som_y,som_x) + 1)));
                        w(:,w_points) = w(:,w_points) + beta * (k_temp(:,1) - w(:,w_points));
                    
                    otherwise
                        w(:,(c(som_y,som_x) - 1)) = w(:,(c(som_y,som_x) - 1)) + beta * (k_temp(:,1) - w(:,(c(som_y,som_x) - 1)));
                        w(:,(c(som_y,som_x) + 1)) = w(:,(c(som_y,som_x) + 1)) + beta * (k_temp(:,1) - w(:,(c(som_y,som_x) + 1)));
                end
            end
        end
    end
    
    disp(strcat(num2str(round(t/loop*100)),'% of learning was finished'))
    som_cdata = whiter(c, hsv(w_points), 1, w_points, peak_point);
    
    figure(100);imagesc(x,z*100,som_cdata);colormap(hsv(w_points));colorbar
    xlabel('Position X (cm)');ylabel('Distance from antenna (cm)');ylim([CUT_DISTANCE1 CUT_DISTANCE2]);caxis([0 w_points])
    mov(t) = getframe(100);
end
toc
close 100

figure('Name','SOM�ł̃s�[�N���ތ���');imagesc(x,z*100,som_cdata);colormap(hsv(w_points));colorbar
xlabel('Position X (cm)');ylabel('Distance from antenna (cm)');ylim([CUT_DISTANCE1 CUT_DISTANCE2]);caxis([0 w_points])


%% �K�E�X���z���o�͂���֐�

function f = gaussian(x,m,s)
f = exp(-(x-m).^2/2/s^2);
end

%% �Q�ƃx�N�g�����쐬����֐�

function w = w_init(w_points ,w_scale ,k_dim)
w_A = w_scale*rand(k_dim, w_points);
w_P = 2*pi*rand(k_dim, w_points);
w = w_A.*exp(1i*w_P);
end

%% ���֌W�G���A�𔒔�������֐�

function c_out = whiter(input_data, color_type, min, max, check_matrix)
cm = colormap(color_type);
cdata = interp1(linspace(min,max,length(cm)),cm,input_data);
SCALE_X = length(input_data(1,:,1));
SCALE_Y = length(input_data(:,1,1));
SCALE_Z = length(input_data(1,1,:));

for k = 1:SCALE_X
    for i = 1:SCALE_Y
        for m = 1:SCALE_Z
            if check_matrix(i,k,m) == 0
                cdata(i,k,m,:) = [1,1,1];
            end
        end
    end
end

c_out = cdata;
end
