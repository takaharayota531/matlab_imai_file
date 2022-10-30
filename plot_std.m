function p_all = plot_std(varargin)
if mod(size(varargin),2)==1
    fig = figure(varargin{end});
    varargin(end) = [];
end
N = numel(varargin)/2;
x = varargin(1:2:end);
y = varargin(2:2:end);
p_all = {};

figure;
for i = 1:N
    x1 = reshape(x{i},[],1);
    N2 = numel(x1);
    f = [1:N2 N2*2:-1:N2+1];
    y1 = mean(y{i},2);
    y2 = std(y{i},1,2);
    p = plot(x1,y1); hold on;
    p_all{end+1} = p;
    v = horzcat(vertcat(x1,x1),vertcat(y1+y2,y1-y2));
    patch('Faces',f,'Vertices',v,'FaceColor',p.Color,'FaceAlpha',.3,'LineStyle','none');
end
xlim([min([x{:}]) max([x{:}])]);

end