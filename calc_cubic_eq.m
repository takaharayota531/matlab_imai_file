% solve cubic equations

function x = calc_cubic_eq(a,b,c,d)
% a - coefficient of x^3
% b - coefficient of x^2
% c - coefficient of x^1
% d - coefficient of x^0

l = b./a;
m = c./a;
n = d./a;
p = m-l.^2/3;
q = n-l.*m/3+2*l.^3/27;

w = -1/2+sqrt(3)/2*1i;

u = (-q/2+sqrt((q/2).^2+(p/3).^3)).^(1/3);
v = (-q/2-sqrt((q/2).^2+(p/3).^3)).^(1/3);
y1 = u+v;
y2 = w*u+w^2*v;
y3 = w^2*u+w*v;

N = ndims(y1);
y = cat(N+1,y1,y2,y3);

x = y-l/3;
end