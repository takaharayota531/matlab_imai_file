function h = sparse_matrix(s,model,sample_list,sample)

[Nx,Ny,Nf] = size(s);
Np = sum(model==1,'all');
Nm = Nx*Ny-Np;
% Np = 1;
% Nm = 1;
m = size(model,1);
% model = model*(1/Np+1/Nm)-1/Nm;
r = (m-1)/2;
B_inv = zeros(Nx*Ny,Nx*Ny);
sample_vec = reshape(sample,1,Nx*Ny);
for mx = 1:Nx
    for my = 1:Ny
%         filter = -ones(Nx,Ny)/Nm;
filter = zeros(Nx,Ny);
        filter(rem((mx-r:mx+r)+Nx-1,Nx)+1,rem((my-r:my+r)+Ny-1,Ny)+1) = model;
%         filter = filter+1/Nm;
        filter_vec = reshape(filter,1,Nx*Ny);
        Np = sum(sample_vec.*(filter_vec==1),'all');
        if Np==0 || Nm==0
            error('The number of samples are not enough');
        end
        if Np~=0
            Np = 1/Np;
        end
        Nm = sum(sample_vec.*(filter_vec==-1),'all');
        if Nm~=0
            Nm = 1/Nm;
        end
        filter_vec = (filter_vec==1)*Np-(filter_vec==-1)*Nm;
        B_inv(mx+(my-1)*Ny,:) = filter_vec;
    end
end

% figure; imagesc(filter);

n = size(sample_list,2);
L = zeros(n,Nx*Ny);
for i = 1:n
    L(i,sample_list(1,i)+(sample_list(2,i)-1)*Ny) = 1;
end
A_inv = B_inv*L';
A = pinv(A_inv);
s_vec = reshape(s,Nx*Ny,Nf);
s_sample = L*s_vec;
x_vec = zeros(Nx*Ny,Nf);
for f = 1:Nf
    x_vec(:,f) = A_inv*s_sample(:,f);
end
x = reshape(x_vec,Nx,Ny,Nf);

% xの表示
show_s(x);

h_vec = sqrt(sum(x_vec.*conj(x_vec),2));
h = reshape(h_vec,Nx,Ny);
figure; imagesc(h);
end
