function show_sample(sample_list,s)
sample_array = zeros(21,21);
length = size(sample_list,2);
for i = 1:length
    sample_array(sample_list(1,i),sample_list(2,i)) = 1;
end
fig = figure;
fig.Position = [0 660 1960 300];
s_max = max(abs(s),[],'all');
s_min = min(abs(s),[],'all');
for i = 1:11
subplot(2,11,i); 
imshow(abs(s(:,:,i)).*sample_array,'DisplayRange',[s_min s_max],'Colormap',parula);
subplot(2,11,i+11); 
imshow(angle(s(:,:,i))/pi*360.*sample_array,'DisplayRange',[-180 180],'Colormap',hsv);
end