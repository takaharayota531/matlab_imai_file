classdef Data
    properties
        s % 散乱画像
        k % 特徴量ベクトル
        h % モデル内の一様性
        sample_list % 取り出したデータの位置
        s_history % 散乱画像の履歴
        k_history % 特徴量ベクトルの履歴
        h_history % モデル内の一様性の履歴
        l % 特徴量のウィンドウの大きさ
        m % モデルの大きさ
        Nx % x方向のピクセル数
        Ny % y方向のピクセル数
        Nf % 周波数サンプル数
        Nk % 特徴量ベクトルの次元数
    end
    methods
        function obj = Data(filename,fileHname,l,m) % コンストラクタ
            obj.Nx = 21;
            obj.Ny = 31;
            obj.Nf = 101;
            obj.s = data_load(filename,fileHname,obj.Nx,obj.Ny,obj.Nf);
            obj.Nf = size(obj.s,3); % 周波数は全体からいくつか抜き取るのでここで更新
            obj.l = l; %特徴量のウィンドウの大きさ
            obj.m = m; %モデルの大きさ
            obj.Nk = 5+(obj.Nf-1)
            obj.k = obj.calc_k(obj.s,l); % 特徴量の計算
            obj.h = obj.calc_h(obj.k,m); % 一様性の計算
            obj.s_history = zeros(obj.Nx,obj.Ny,obj.Nf,0); % 散乱画像の履歴の初期化
            obj.k_history = zeros(obj.Nx-(l-1),obj.Ny-(l-1),obj.Nk,0); 
            obj.h_history = zeros(obj.Nx-(l-1)-(m-1),obj.Ny-(l-1)-(m-1),0);
            obj.sample_list = zeros(2,0);
        end
        function diff = calc_diff(obj) % 目的関数の微分の計算
            diff = calc_difh_2_2(obj.s_history(:,:,:,end),obj.k_history(:,:,:,end),obj.l,obj.m);
        end
        function obj = sample(obj,ratio) % データの取り出し
            [obj.s_history(:,:,:,end+1),obj.sample_list] = data_sample(obj.s,ratio);
        end
        function obj = fill(obj)
            obj.s_history(:,:,:,1) = data_fill(obj.s_history(:,:,:,1),obj.sample_list);
        end
        function obj = grad(obj) % 再急降下法
            obj = gradient_descent_1(obj);
        end
        function obj = show_history(obj) % hの変化をスライダーで表示
            show_history(obj.h_history);
        end
        function alpha = armijo(obj,d) % アルミホの条件からステップ幅を計算
            alpha = 1;
            c = 0.3;
            rho = 0.5;
            while 1
                fi = norm(reshape(obj.calc_h(obj.calc_k(obj.s_history(:,:,:,end)-alpha*d,obj.l),obj.m),[],1),1);
                fi_2 = norm(reshape(obj.calc_h(obj.calc_k(obj.s_history(:,:,:,end),obj.l),obj.m),[],1),1)-c*sum(abs(d).^2,'all')*alpha;
                if fi <= fi_2
                    break
                end
                alpha = alpha*rho;
            end
        end
    end
    methods(Static)
        function k = calc_k(s,l) %特徴量の計算
            k = calc_k(s,l);
        end
        function h = calc_h(k,m) % 一様性の計算
            h = calc_h_4_3(k);
        end
    end
    
end

