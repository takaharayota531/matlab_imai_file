function [w_out, c_out] = mineclass_set(w_in, c_in, x, y, set, w_points)
mine_class = c_in(x,y); %地雷があるとわかっている点の特徴量を地雷クラスとする．
if mine_class < set
    for i = 1:(set - mine_class)
        w_in = rotationW(w_in);
        c_in = rotationC(c_in, w_points);
    end
elseif mine_class > set
    for i = 1:((w_points + set) - mine_class)
            w_in = rotationW(w_in);
            c_in = rotationC(c_in, w_points);
    end
end
w_out = w_in;
c_out = c_in;