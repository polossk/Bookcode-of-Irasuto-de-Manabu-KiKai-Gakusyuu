%% Example 6.1 L1-Constrained Least Huber Loss Regression
%
% * *Result in book* : Figure 6.13
% * *Code in book* : Figure 6.14
% * *Output* : |eg6_3.png|
% * *Usage* : |eg6_3(), eg6_3(50, 1000)|
%
%% Source Code
function eg6_3(n, N)
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
	y(n / 2) = -0.5;

	hh = 2 * 0.3 ^ 2;
	l = 0.1;
	e = 0.1;
	t0 = randn(n, 1);
	x2 = x .^ 2;
	X2 = X .^ 2;
	k = exp(-(repmat(x2, 1, n) + repmat(x2', n, 1) - 2 * x * x') / hh);
	K = exp(-(repmat(X2, 1, n) + repmat(x2', N, 1) - 2 * X * x') / hh);

	% Least Square Loss Regression, (\lambda, \eta) = (0, \inf)
	for o = 1 : (n * 10000)
		index = ceil(rand * n);
		ki = exp(-(x - x(index)) .^ 2 / hh);
		t = t0 - e * ki * (ki' * t0 - y(index));
		if norm(t - t0) < 1e-7, break, end
		t0 = t;
    end
	F1 = K * t;

	% L1-Constrained Least Square Loss Regression, (\lambda, \eta) = (0.1, \inf)
	k2 = k ^ 2; ky = k * y;
	t0 = randn(n, 1);
	for o = 1 : (n * 1000)
		t = (k2 + l * pinv(diag(abs(t0)))) \ ky;
		if norm(t - t0) < 1e-4, break, end
		t0 = t;
    end
	F2 = K * t;

	% Least Huber Loss Regression, (\lambda, \eta) = (0, 0.1)
	t0 = randn(n, 1);
	for o = 1 : 1000
		r = abs(k * t0 - y);
		w = ones(n, 1); w(r > e) = e ./ r(r > e);
		Z = k * (repmat(w, 1, n) .* k);
		t = (Z + 0.000001 * eye(n)) \ (k * (w .* y));
		if norm(t - t0) < 1e-4, break, end
		t0 = t;
    end
	F3 = K * t;

	% L1-Constrained Least Huber Loss Regression, (\lambda, \eta) = (0.1, 0.1)
	t0 = randn(n, 1);
	for o = 1 : 1000
		r = abs(k * t0 - y);
		w = ones(n, 1); w(r > e) = e ./ r(r > e);
		Z = k * (repmat(w, 1, n) .* k) + l * pinv(diag(abs(t0)));
		t = (Z + 0.1 * eye(n)) \ (k * (w .* y));
		if norm(t - t0) < 1e-3, break, end
		t0 = t;
    end
	F4 = K * t;

	figure('Name', 'example 6-3'); clf; hold on;
	axis([-2.8 2.8 -1 1.5]);
	plot(X, F1, 'b-', X, F2, 'm-', X, F3, 'g-', X, F4, 'r-', x, y, 'cp');
	legend('LS', 'L1-Constrained LS', ...
		'Least Huber', 'L1-Constrained Least Huber', ...
        'Input Data', 'Location', 'southeast');
	saveas(gcf, 'eg6_3', 'png');
end