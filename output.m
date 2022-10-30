% 画像出力用関数

function output(data)

amax = max(data_xy2_db(:,:,:,1),[],'all');
amin = min(data_xy2_db(:,:,:,1),[],'all');
fig = figure;
for i = 0:10
    fig.Position = [680 300 530 640];
    fn = num2str(8+0.4*i,'%0.1f');
    fre = num2str((8+0.4*i)*10);
    im = image(data_xy2_db(:,:,1+i,1));
    im.CDataMapping = 'scaled';
    colormap jet;
    caxis([-100 -28]); 
    fig.PaperPositionMode = 'auto'
    fig_pos = fig.PaperPosition;
    fig.PaperSize = [fig_pos(4) fig_pos(4)];
    filename = horzcat('images\', '20200923_mine02_amp_', fre, 'GHz', '.png');
    title(horzcat(fn,'GHz'),'fontsize',100);
    saveas(fig,filename);
    
    
    fig.Position = [680 300 560 530];
    im = image(data_xy2_db(:,:,1+f_int*i,2));
    im.CDataMapping = 'scaled';
    colormap jet;
    caxis([-180 180]); 
    fig.PaperPositionMode = 'auto'
    fig_pos = fig.PaperPosition;
    fig.PaperSize = [fig_pos(3) fig_pos(4)];
    filename = horzcat('images\', '20200923_mine02_phase_', fre, 'GHz', '.png');
    saveas(fig,filename);
end

% カラーバーの出力
fig.Position = [680 300 560 580];
fn = num2str(8+0.4*i,'%0.1f');
fre = num2str((8+0.4*i)*10);
im = image(data_xy2_db(:,:,1+f_int*i,1));
im.CDataMapping = 'scaled';
colormap jet;
caxis([-100 -28]);
colorbar('TickLabelInterpreter','tex','ticks',[-90 -60 -30],'ticklabels',{'\fontsize{40} -90','\fontsize{40} -60','\fontsize{40} -30'});
fig.PaperPositionMode = 'auto'
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(4) fig_pos(4)];
filename = horzcat('images\', '20200923_mine02_amp_', 'bar', '.png');
title(horzcat(fn,'GHz'),'fontsize',60);
saveas(fig,filename);

% 
% fig.Position = [680 300 560 530];
% im = image(data_xy2_db(:,:,1+f_int*i,2),'x',[1,15]);
% im.CDataMapping = 'scaled';
% colormap jet;
% caxis([-180 180]);
% colorbar('TickLabelInterpreter','tex','ticks',[-180 0 180],'ticklabels',{'\fontsize{40} -180','\fontsize{40} 0','\fontsize{40} 180'});
% fig.PaperPositionMode = 'auto'
% fig_pos = fig.PaperPosition;
% fig.PaperSize = [fig_pos(3) fig_pos(4)];
% filename = horzcat('images\', '20200923_mine02_phase_', 'bar', '.png');
% saveas(fig,filename);
end


