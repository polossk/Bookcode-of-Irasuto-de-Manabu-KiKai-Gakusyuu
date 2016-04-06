%% Example 3.2 Basic Linear Regression with Stochastic Gradient Descent Method
%
% * *Result in book* : Figure 3.7
% * *Code in book* : Figure 3.8
% * *Output* : |eg3_2_A.png, eg3_2_B.png|
% * *Usage* : |eg3_2(), eg3_2(50, 1000)|
%
%% Source Code
function eg3_2(n, N)
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
	y = sin(pix) ./ pix + 0.1 * x + 0.05 * randn(n, 1);

	% plot preparation
	figure('Name', 'example 3-2 A'); clf; hold on;

	% iteration parameter
	hh = 2 * 0.3 * 0.3;
	K = exp(-(repmat(X .^ 2, 1, n) + repmat((x .^ 2)', N, 1) - 2 * X * x') / hh);
	t0 = randn(n, 1);
	e = 0.1;
	eps = 1e-6;
	id = 1;

	% iteration, plot some data within iteration
	for o = 1 : n * 1000
		index = ceil(rand * n);
		ki = exp(-(x - x(index)) .^ 2 / hh);
		t = t0 - e * ki * (ki' * t0 - y(index));
		if norm(t - t0) < eps, break, end
		if (o == 1) || (rem(o, 50) == 0 && o < 201)
			plotFigure(3, 2, id, num2str(o), X, K * t, x, y);
			id = id + 1;
		end
		t0 = t;
	end

	% plot final iteration result
	plotFigure(3, 2, id, num2str(o), X, K * t, x, y);
	saveas(gcf, 'eg3_2_A', 'png');
	figure('Name', 'example 3-2 B'); clf; hold on;
	plot(X, K * t, 'g-');
	plot(x, y, 'bo');
	setFigure(gca, 'example 3-2 final result');

	% save figure
	saveas(gcf, 'eg3_2_B', 'png');
end
%%
