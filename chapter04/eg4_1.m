%% Example 4.1 Subspace-Constrained Regression with Least Square Method
% 
% * *Result in book* : Figure 4.1
% * *Code in book* : Figure 4.3
% * *Output* : |eg4_1.png|
% * *Usage* : |eg4_1(), eg4_1(50, 1000)|
% 
%% Source Code
function eg4_1(n, N)
	% init
	rng(0);
	% recommended, use it in future instead of
	% rand('state', 0); randn('state', 0);
	if nargin < 2
		n = 50; N = 1000;
	end

	% constant
	x = linspace(-3, 3, n)';
	X = linspace(-3, 3, N)';
	pix = pi * x;
	y = sin(pix) ./ (pix) + 0.1 * x + 0.2 * randn(n, 1);

	% base function
	p(:, 1) = ones(n, 1);
	P(:, 1) = ones(N, 1);
	for jj = 1 : 15
		p(:, 2 * jj) = sin(jj / 2 * x);
		p(:, 2 * jj + 1) = cos(jj / 2 * x);
		P(:, 2 * jj) = sin(jj / 2 * X);
		P(:, 2 * jj + 1) = cos(jj / 2 * X);
	end

	% solve
	t1 = p \ y;
	F1 = P * t1;
	t2 = (p * diag([ones(1, 11) zeros(1, 20)])) \ y;
	F2 = P * t2;

	% plot
	figure('Name', 'example 4-1'); clf; hold on;

	% plot figure 1
	plot(X, F1, 'g-', X, F2, 'r-', x, y, 'bo');
	legend('LS', 'Subspace-Constrained LS', 'Input Data', 'Location', 'southeast');
	axis([-2.8, 2.8 -0.8 1.2]);
	setFigure(gca, 'LS & Subspace-Constrained LS');

	% save figure
	saveas(gcf, 'eg4_1', 'png');
end