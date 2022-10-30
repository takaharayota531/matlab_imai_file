% 距離と周波数による減衰を補正する関数

function s_v = correct_attenuation(s,f,z)
N_IFFT = size(f,2);
[X_POINT,Y_POINT] = size(s,1,2);
c = 299792458; % 光速(m/s)
lamda = c./f';
lamda(1) = inf; 
z(1) = 0;
idft = conj(dftmtx(N_IFFT))/N_IFFT;
idft = idft./(lamda./(4*pi*z)).^2;
s_v = zeros(X_POINT,Y_POINT,N_IFFT);
for x = 1:X_POINT
    for y = 1:Y_POINT
        s_v(x,y,:) = reshape(s(x,y,:),[1,N_IFFT])*idft;
    end
end