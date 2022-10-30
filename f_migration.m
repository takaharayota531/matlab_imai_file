%% frequency-migration

function B = f_migration(A,xp,yp,zp,xm,ym,f,d,h,g)
% A - input data (x*y*f)
% xp - measured positions in x-direction
% yp - measured positions in y-direction
% zp - measured positions in z-direction
% xm - antenna positions in x-direction
% ym - antenna positions in y-drection
% f - measuring frequencies
% d - distance between Tx and Rx antennas
% h - antenna height
% g - distance from calibration standard to tip of antenna 
nu = physconst('lightspeed'); % light speed
e = 4; % relative permittivity in soil
ref_sw = 1; % switch to include reflaction into calculation


[Nxm,Nym,Nfm] = size(A);
Nxp = numel(xp);
Nyp = numel(yp);
Nzp = numel(zp);
progressbar('Frequency Migration progress')
tic;

xp = reshape(xp,Nxp,1,1); % reflected position in x-axis
yp = reshape(yp,1,Nyp,1); % reflected position in y-axis
zp = reshape(zp,1,1,Nzp); % reflected position in z-axis
xm = reshape(xm,1,1,1,Nxm); % measuring position in x-axis
ym = reshape(ym,1,1,1,1,Nym); % measuring position in y-axis
fm = reshape(f,1,1,1,1,1,Nfm); % measuring frequency

Nth = 2^11;
theta_a = reshape(linspace(0,pi/2,Nth),1,1,1,1,1,1,[]);
theta_g = asin(sin(theta_a)/2);

[d_h,d_v,f_dir] = read_directivity;
index_fdir = zeros(1,Nfm);
for i = 1:Nfm
    index_fdir(i) = find(f_dir==fm(i));
end
d_h = d_h(:,index_fdir);
d_v = d_v(:,index_fdir);



dt = 1/Nxp/Nyp; % ratio of 1 loop to the whole

B = zeros(Nxp,Nyp,Nzp); % spatial image

index_a = find(zp<=h+g); % depth index for air
index_g = find(zp>h+g); % depth index for subsurface

R1 = zeros(Nxp,Nyp,Nzp);
R2 = zeros(Nxp,Nyp,Nzp);
theta_a1 = zeros(Nxp,Nyp,Nzp);
theta_a2 = zeros(Nxp,Nyp,Nzp);
for xi = 1:Nxm % reflected position index in x-axis
    for yi = 1:Nym % reflected position index in y-axis
        x1 = xm(xi)-d/2-xp;
        x2 = xm(xi)+d/2-xp;
        y = ym(yi)-yp;
        Rh1 = sqrt(x1.^2+y.^2); % horizontal distance from Tx to the point
        Rh2 = sqrt(x2.^2+y.^2); % horizontal distance from Rx to the point
        zp2 = zp - g; % depth from tip of antenna
        
        switch ref_sw
            case 0
                % straight route
                theta_a1 = atan(Rh1./zp2);
                theta_a2 = atan(Rh2./zp2);
                R1 = zp2./cos(theta_a1);
                R2 = zp2./cos(theta_a2);
            case 1
                % include refraction
                % calculate path length to air point
                theta_a1(:,:,index_a) = atan(Rh1./zp2(index_a));
                theta_a2(:,:,index_a) = atan(Rh2./zp2(index_a));
                R1(:,:,index_a) = zp2(index_a)./cos(theta_a1(:,:,index_a));
                R2(:,:,index_a) = zp2(index_a)./cos(theta_a2(:,:,index_a));

                % calculate path length to subsurface point
                z = zp2(index_g)-h; % depth from ground surface

                % calculate refraction angle
                [theta_a1(:,:,index_g),theta_g1] = calc_angle(h,z,Rh1,e); % incidence angle
                [theta_a2(:,:,index_g),theta_g2] = calc_angle(h,z,Rh2,e); % reflection angle

                R1(:,:,index_g) = h./cos(theta_a1(:,:,index_g))+z./cos(theta_g1)*sqrt(e); % incidence path length
                R2(:,:,index_g) = h./cos(theta_a2(:,:,index_g))+z./cos(theta_g2)*sqrt(e); % reflection path length
        end

        temp = reshape(A(xi,yi,:),1,1,1,1,1,Nfm).*exp(1i*2*pi*fm.*(2*g+R1+R2)/nu); % rotation of phase;
        
        %         temp = temp.*PRw(xi,yi,:,:,:,:); % 位相復元結果の周波数特性を重み付けする
        %         temp = temp.*(R1.*R2).^2; % correct distance attenuation of signals

        % 指向性による補正
        %             theta_h = atan(tan(theta_a1)./sqrt(1+x./y));
        %             theta_v1 = atan(tan(theta_a1)./sqrt(1+y./x));
        %             theta_v2 = atan(tan(theta_a2)./sqrt(1+y./x));
        %             temp = conj(reshape(d_v(theta_v1,:).*d_v(theta_v2,:),1,1,Nzp,Nxm,1,Nfm)...
        %                 .*reshape(d_h(theta_h,:).^2,1,1,Nzp,1,Nym,Nfm))...
        %                 .*temp;

        B = B + sum(temp,6); % sum signals from all antenna positions
        progressbar(dt*(yi+Nyp*(xi-1)));
    end
end
B = B/Nxm/Nym/Nfm; % devide with number of reflection positions
close
toc;
end