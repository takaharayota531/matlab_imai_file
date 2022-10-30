function h = calc_h_3D(k,model,t)
[Nx,Ny,Nz,Nk] = size(k);
h = zeros(Nx,Ny,Nz);
for z = 1:Nz
    k_temp = squeeze(k(:,:,z,:));
    h(:,:,z) = calc_h(k_temp,model);
end

if t>1
    for z = 1:Nz-t+1;
        h(:,:,z) = sum(h(:,:,z:z+t-1),3);
    end
    h(:,:,Nz-t+2:Nz) = [];
end