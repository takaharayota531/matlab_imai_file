%% calculate Refraction Angles
function [theta_a,theta_g] = calc_angle(h,z,x,e)
% theta_a - incidence/refraction angle in air
% theta_a - incidence/refraction angle in ground
% h - height of antenna
% z - depth of measured point
% x - horizontal distances from antenna to measured points
% e - relative permittivity of soil

% calculate coefficients of quartic equation
a4 = 1;
a3 = -2*x/h;
a2 = ((e-1).*x.^2+e*h^2-z.^2)/((e-1)*h^2);
a1 = -2*e*x/(e-1)/h;
a0 = e*x.^2/(e-1)/h^2;
temp = zeros(size(h.*z.*x));
a4 = a4+temp;
a3 = a3+temp;
a2 = a2+temp;
a1 = a1+temp;
a0 = a0+temp;

S = calc_quartic_eq(a3,a2,a1,a0);
tana = S;
tang = tana./sqrt(3*tana.^2+4);
N = ndims(a4);
er = h*tana+z.*tang-x;
[~,I] = min(er,[],N+1,'linear');
tana = tana(I);
tang = tang(I);
theta_a = atan(tana); % return as real number
theta_g = atan(tang); % return as real number
% syms t
% eqn = a4*t^4 + a3*t^3 + a2*t^2 + a1*t + a0 == 0;
% S = solve(eqn, t, 'MaxDegree', 4);
end