% load('cmapmine7of8', 'mine7of8');
i = 130;
w_points = 8;
alpha = 0.2;
beta = 0.05;
% figure(1);
% for k = 1:32
% i = k+64;
% [w1, c1] = segment_image2('20140309_mine5', w_points, alpha, beta, floor((i-1)/8)*2+2,mod((i-1),8)+1);
% [w1, c1] = mineclass_set(w1, c1, 17, 13, 1, w_points);
% subplot(4,8,k); imagesc(c1'); caxis([1 w_points]); colormap(hsv(w_points));
% set( gca, 'FontName','Times','FontSize',12 );
% % set(i, 'Position', [200 200 320 180]);
% % set(i, 'Colormap', mine7of8);
% colorbar('FontName','Times','FontSize',12);
% end
% 
dataname = '20170221_mine10';
[w1, c1] = segment_image2(dataname, w_points, alpha, beta, 1, 1);
[w1, c1] = mineclass_set(w1, c1, 8, 6, 7, w_points);
figure(i); imagesc(c1'); caxis([1 w_points]); colormap(hsv(w_points));
set( gca, 'FontName','Times New Roman','FontSize',12 );
% set(i, 'Position', [200 200 320 180]);
% set(i, 'Colormap', mine7of8);
colorbar('FontName','Times New Roman','FontSize',12);
datanamef = horzcat('..\..\201610\', dataname, '_som_old2.eps');
print(i, '-depsc', datanamef)
% i = i+1;
% [w1, c1] = segment_image2('20140306_mine3', w_points, alpha, beta);
% [w1, c1] = mineclass_set(w1, c1, 8, 6, 1, w_points);
% figure(i); imagesc(c1); caxis([1 w_points]); colormap(hsv(w_points));
% set( gca, 'FontName','Times','FontSize',12 );
% % set(i, 'Position', [200 200 320 180]);
% % set(i, 'Colormap', mine7of8);
% colorbar('FontName','Times','FontSize',12);
% i = i+1;
% [w1, c1] = segment_image2('20140306_mine4', w_points, alpha, beta);
% [w1, c1] = mineclass_set(w1, c1, 8, 6, 1, w_points);
% figure(i); imagesc(c1); caxis([1 w_points]); colormap(hsv(w_points));
% set( gca, 'FontName','Times','FontSize',12 );
% % set(i, 'Position', [200 200 320 180]);
% % set(i, 'Colormap', mine7of8);
% colorbar('FontName','Times','FontSize',12);
% i = i+1;
% [w1, c1] = segment_image2('20140306_mine5', w_points, alpha, beta);
% [w1, c1] = mineclass_set(w1, c1, 8, 6, 1, w_points);
% figure(i); imagesc(c1); caxis([1 w_points]); colormap(hsv(w_points));
% set( gca, 'FontName','Times','FontSize',12 );
% % set(i, 'Position', [200 200 320 180]);
% % set(i, 'Colormap', mine7of8);
% colorbar('FontName','Times','FontSize',12);
% i = i+1;
% [w1, c1] = segment_image2('20140306_mine6', w_points, alpha, beta);
% [w1, c1] = mineclass_set(w1, c1, 8, 6, 1, w_points);
% figure(i); imagesc(c1); caxis([1 w_points]); colormap(hsv(w_points));
% set( gca, 'FontName','Times','FontSize',12 );
% % set(i, 'Position', [200 200 320 180]);
% % set(i, 'Colormap', mine7of8);
% colorbar('FontName','Times','FontSize',12);
% i = i+1;
% [w1, c1] = segment_image2('20140306_mine7', w_points, alpha, beta);
% [w1, c1] = mineclass_set(w1, c1, 8, 6, 1, w_points);
% figure(i); imagesc(c1); caxis([1 w_points]); colormap(hsv(w_points));
% set( gca, 'FontName','Times','FontSize',12 );
% % set(i, 'Position', [200 200 320 180]);
% % set(i, 'Colormap', mine7of8);
% colorbar('FontName','Times','FontSize',12);
% i = i+1;
% [w1, c1] = segment_image2('20140306_mine8', w_points, alpha, beta);
% [w1, c1] = mineclass_set(w1, c1, 8, 6, 1, w_points);
% figure(i); imagesc(c1); caxis([1 w_points]); colormap(hsv(w_points));
% set( gca, 'FontName','Times','FontSize',12 );
% % set(i, 'Position', [200 200 320 180]);
% % set(i, 'Colormap', mine7of8);
% colorbar('FontName','Times','FontSize',12);

% [w1, c1] = segment_image2('20140219_mine5', w_points, alpha, beta);
% [w1, c1] = mineclass_set(w1, c1, 10, 12, 2);
% figure(i); imagesc(c1); caxis([1 w_points]); colormap(hsv(w_points)); colorbar;
% 
% figure(i)
% for p = 1 : 11
% [w1, c1] = segment_image2('20140219_mine1', w_points, alpha, beta);
% [w1, c1] = mineclass_set(w1, c1, 8, 6, 2);
%     subplot(2,11,p);imagesc(c1);axis square; axis on;
%     title([num2str(p)],'Fontsize',12);
%     if p == 11
%         colorbar('location','eastoutside');
%     end
%     caxis([1 w_points]); colormap(hsv(w_points));
% end
% i = i+1;
% figure(i)
% for p = 1 : 11
% [w1, c1] = segment_image2('20140219_mine1', w_points, alpha, beta);
% [w1, c1] = mineclass_set(w1, c1, x, y, 2);
%     subplot(2,11,p);imagesc(c1);axis square; axis on;
%     title([num2str(p)],'Fontsize',12);
%     if p == 11
%         colorbar('location','eastoutside');
%     end
%     caxis([1 w_points]); colormap(hsv(w_points));
% end
% i = i+1;
% figure(i)
% for p = 1 : 11
% [w1, c1] = segment_image2('20140219_mine2', w_points, alpha, beta);
% [w1, c1] = mineclass_set(w1, c1, x, y, 2);
%     subplot(2,11,p);imagesc(c1);axis square; axis on;
%     title([num2str(p)],'Fontsize',12);
%     if p == 11
%         colorbar('location','eastoutside');
%     end
%     caxis([1 w_points]); colormap(hsv(w_points));
% end
% i = i+1;
% alpha = 0.4;
% beta = 0.2;
% figure(i)
% for p = 1 : 11
% [w1, c1] = segment_image2('20140218_mine1', w_points, alpha, beta);
% [w1, c1] = mineclass_set(w1, c1, x, y, 2);
%     subplot(2,11,p);imagesc(c1);axis square; axis on;
%     title([num2str(p)],'Fontsize',12);
%     if p == 11
%         colorbar('location','eastoutside');
%     end
%     caxis([1 w_points]); colormap(hsv(w_points));
% end
% i = i+1;
% figure(i)
% for p = 1 : 11
% [w1, c1] = segment_image2('20140219_mine1', w_points, alpha, beta);
% [w1, c1] = mineclass_set(w1, c1, x, y, 2);
%     subplot(2,11,p);imagesc(c1);axis square; axis on;
%     title([num2str(p)],'Fontsize',12);
%     if p == 11
%         colorbar('location','eastoutside');
%     end
%     caxis([1 w_points]); colormap(hsv(w_points));
% end
% i = i+1;
% figure(i)
% for p = 1 : 11
% [w1, c1] = segment_image2('20140219_mine2', w_points, alpha, beta);
% [w1, c1] = mineclass_set(w1, c1, x, y, 2);
%     subplot(2,11,p);imagesc(c1);axis square; axis on;
%     title([num2str(p)],'Fontsize',12);
%     if p == 11
%         colorbar('location','eastoutside');
%     end
%     caxis([1 w_points]); colormap(hsv(w_points));
% end

% [w2, c2] = segment_image('20140213_mine2', '20140213_direct');
% [w2, c2] = mineclass_set(w2, c2, x, y, 2);
% figure(2);imagesc(c2); colormap(hsv(10)); colorbar;
% 
% [w3, c3] = segment_image('20140213_mine3', '20140213_direct');
% [w3, c3] = mineclass_set(w3, c3, x, y, 2);
% figure(3);imagesc(c3); colormap(hsv(10)); colorbar;
% 
% [w4, c4] = segment_image('20140213_mine4', '20140213_direct');
% [w4, c4] = mineclass_set(w4, c4, x, y, 2);
% figure(4);imagesc(c4); colormap(hsv(10)); colorbar;
% 
% [w5, c5] = segment_image('20140215_mine1', '20140213_direct');
% [w5, c5] = mineclass_set(w5, c5, x, y, 2);
% figure(5);imagesc(c5); colormap(hsv(10)); colorbar;
% 
% [w6, c6] = segment_image('20140215_mine2', '20140213_direct');
% [w6, c6] = mineclass_set(w6, c6, x, y, 2);
% figure(6);imagesc(c6); caxis([1 10]);colormap(hsv(10)); colorbar;

% %内積ー平均、全ての平均を計算する
% [DataMean, MeanAll, data_temp] = scalar_product_temp(w6,c6,w1,w2,w3,w4,w5,w6);
% 
% figure(11);plot(1:10,data_temp);
% figure(7);plot(1:10,DataMean);
% figure(8);plot(1:10,MeanAll);
% % 地雷マップを作製、c1のマップにmean_allの結果を反映させる
% [MineMap1] = TYPE1_MineDetect(c6, MeanAll);
% [MineMap2] = TYPE2_MineDetect(c6, MeanAll);
% figure(9);imagesc(MineMap1);colormap(gray);colorbar;
% % figure(10);imagesc(MineMap2);colormap(gray);colorbar;
