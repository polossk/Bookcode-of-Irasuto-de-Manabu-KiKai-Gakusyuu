%% Example 4.2 L2-Constrained Regression with Least Square Method
%
% * *Result in book* : Figure 4.6
% * *Code in book* : Figure 4.7
% * *Output* : |eg4_2.png|
% * *Usage* : |eg4_2(), eg4_2(50, 1000)|
%
%% Source Code
function eg4_2(n, N)
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

	% kernel function
	x2 = x .^ 2;
	X2 = X .^ 2;
	hh = 2 * 0.3 ^ 2;
	l = 0.1;
	k = exp(-(repmat(x2, 1, n) + repmat(x2', n, 1) - 2 * x * x') / hh);
	K = exp(-(repmat(X2, 1, n) + repmat(x2', N, 1) - 2 * X * x') / hh);

	% solve
	t1 = k \ y;
	F1 = K * t1;
	t2 = (k ^ 2 + l * eye(n)) \ (k * y);
	F2 = K * t2;

	% plot
	figure('Name', 'example 4-2'); clf; hold on;

	% plot figure 1
	plot(X, F1, 'g-', X, F2, 'r-', x, y, 'bo');
	legend('LS', 'L2-Constrained LS', 'Input Data');
	axis([-2.8 2.8 -1 1.5]);
	setFigure(gca, 'LS & L2-Constrained LS');

	% save figure
	saveas(gcf, 'eg4_2', 'png');
end