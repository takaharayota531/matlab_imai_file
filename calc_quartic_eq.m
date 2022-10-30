% solve quartic_equations

function x = calc_quartic_eq(A,B,C,D)
% A - coefficient of x^3
% B - coefficient of x^2
% C - coefficient of x^1
% D - coefficient of x^0

% create y matrix (input size *4
N = ndims(A);

p = -3/8*A.^2+B;
q = 1/8*A.^3-1/2*A.*B+C;
r = -3/256*A.^4+1/16*A.^2.*B-1/4*A.*C+D;

b3 = 1;
b2 = -p/2;
b1 = -r;
b0 = r.*p/2-q.^2/8;
t_temp = calc_cubic_eq(b3,b2,b1,b0);
t=max(t_temp,[],N+1);
m = sqrt(2*t-p);
n = sqrt(t.^2-r);
u = sqrt(m.^2-4*(t+n));
v = sqrt(m.^2-4*(t-n));

y = cat(N+1,(-m+u)/2,(-m-u)/2,(m+v)/2,(m-v)/2);

x = y-1/4*A;
end