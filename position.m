%Function M-file:position.m
%データを実際の位置の行列に配置する
%a:input data
%f:f_number
%c:output data

function data_xy = position(data,f_num,Ylen)

if f_num < eps;
    disp('データが不十分です（position.m）');
end;

data_xy = zeros(21,Ylen,f_num);

r_to_x = [4 21 15 9 3 19 13 7 1 17 11 5 20 14 8 2 18 12 6 16 10 4]; % 測定したデータのx座標を並べた配列

for q = 1:Ylen
    for p = 21 * f_num * (q-1) + 1: 21 * f_num * q % データ配列を各y座標ごとに処理
            data_xy(r_to_x(1,(ceil((mod(p,2121))/101))+1),q,rem(p-1,f_num)+1)=data(p);
    end
end
data_xy = flip(data_xy,2);
data_xy = permute(data_xy,[2 1 3]);


%data_xy = zeros(23,21,5,f_num);
%
% for m = 1:5
%     
%     switch m;
%         case 1
%           for x = 1:12
%              for y = 1:11
%                 data_xy(x,y,m,1:f_num) = data((1 + f_num *(11 * (x - 1 ) + y - 1 )):(f_num * (11 * (x - 1 ) + y )));
%              end
%           end
%     
%          case 2
%             for x = 1:12
%                for y = 1:10
%                   data_xy(x,y,m,1:f_num) = data((f_num * 132 + 1 + f_num * (10 * (x - 1 ) + y - 1 )):(f_num * 132 + f_num * ( 10 * (x - 1 ) + y )));
%                end
%             end
%      
%         case 3
%             for x = 1:11
%                for y = 1:12
%                   data_xy(x,y,m,1:f_num) = data((f_num * (132 + 120 ) + 1 + f_num * (12 * (x - 1 ) + y - 1 )):(f_num * (132 + 120 ) +f_num * ( 12 * (x - 1) + y )));
%                end
%             end
%         
%         case 4
%            for x = 1:11
%                for y = 1:11
%                    data_xy(x,y,m,1:f_num) = data((f_num * (132 + 120 + 132 ) + 1 + f_num * (11 * (x - 1 ) + y - 1 )):(f_num * (132 + 120 + 132 ) + f_num * (11 * (x - 1 ) + y )));
%                end 
%            end
%         
%         case 5
%             data_xy(1:2:23,1:2:21,m,1:f_num) = data_xy(1:12,1:11,1,:);
%             data_xy(1:2:23,2:2:21,m,1:f_num) = data_xy(1:12,1:10,2,:);
%             data_xy(2:2:23,2:2:21,m,1:f_num) = data_xy(1:11,2:11,3,:);
%             data_xy(2:2:23,1:2:21,m,1:f_num) = data_xy(1:11,1:11,4,:);
%             
%     end
% end
%     
    %end of file