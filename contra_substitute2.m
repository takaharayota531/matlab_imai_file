%Function M-file:contra_substitute.m
%���f�����炄�a�ƃƂɂ�����



function data_dB_t = contra_substitute2(data )

if data < eps
    disp('�f�[�^�s���ł��icontra_substitute.m�j');
end

data_dB_t(:,:,:,1) = mag2db(abs(data(:,:,:)));
data_dB_t(:,:,:,2) = angle(data(:,:,:)) * 180 / pi; %�R�U�O�x�ŕԂ�

%end function