function model = make_model(r,t)
model = zeros(2*(r+t)+1,2*(r+t)+1); % モデルの形状を記録
for x = 1:2*(r+t)+1
    for y = 1:2*(r+t)+1
        rp = sqrt((x-(r+t)-1)^2+(y-(r+t)-1)^2);
        if rp<=r+t+0.5 && r+0.5<=rp % 円の外側
            model(x,y) = -1;
        elseif rp<=r+0.5
            model(x,y) = 1; % 円の内側
        end
    end
end

% モデルの形状を表示
% figure;imagesc(model);colormap(gray);