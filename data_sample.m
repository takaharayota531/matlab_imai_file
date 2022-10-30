function [s,sample,sample_list] = data_sample(s,ratio)
[Nx,Ny] = size(s,1,2);
n = Nx*Ny*ratio/100;
sample_tmp = randsample(Nx*Ny,n);
sample_tmp = sort(sample_tmp)';
sample_list = [floor((sample_tmp-1)/Nx)+1;rem(sample_tmp-1,Nx*ones(1,n))+1];
sample = zeros(Nx,Ny);
i = 1;
for x = 1:Nx
    for y = 1:Ny
        if i<=n && x==sample_list(1,i) && y==sample_list(2,i)
            sample(x,y) = 1;
            i = i+1;
        else
            s(x,y,:) = 0;
        end
    end
end
