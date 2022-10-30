s = zeros(21,21);
center = [13 9];
for x = 1:21
    for y = 1:21
        if norm([x y] - center) < 7
            s(x,y) = 1;
        end
    end
end
figure;
imagesc(s);