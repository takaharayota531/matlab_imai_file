%隣接するピクセルとの位相差をとる

function s_after = s_ext(s)
[Nx,Ny,Nf] = size(s);
x = 1:Nx;
y = 1:Ny;
f = 1:Nf;
s_after = zeros(Nx,Ny,2*Nf);
s_after(x,y,f) = s(x,y,f).*conj(s(rem(x,Nx)+1,y,f));
s_after(x,y,f+Nf) = s(x,y,f).*conj(s(x,rem(y,Ny)+1,f));
end