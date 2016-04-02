% init
rand('state', 0);
randn('state', 0);

% constant
n = 50; N = 1000;
x = linspace(-3, 3, n)';
X = linspace(-3, 3, N)';
pix = pi * x;
y = sin(pix) ./ pix + 0.1 * x + 0.05 * randn(n, 1);

% base function
p(:, 1) = ones(n, 1);
P(:, 1) = ones(N, 1);
for jj = 1 : 15
	p(:, 2 * jj) = sin(jj / 2 * x); p(:, 2 * jj + 1) = cos(jj / 2 * x);
	P(:, 2 * jj) = sin(jj / 2 * X); P(:, 2 * jj + 1) = cos(jj / 2 * X);
end

% solve
t = p \ y;
F = P * t;

% plot
figure('Name', 'example 3-1'); clf; hold on;
plot(X, F, 'g-');
plot(x, y, 'bo');
setFigure(gca, 'example 3-1');

% save figure
saveas(gcf, 'eg3_1', 'png');
