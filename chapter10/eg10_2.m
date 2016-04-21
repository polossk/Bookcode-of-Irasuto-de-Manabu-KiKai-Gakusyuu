%% Example 10.2 Least-Squares Probabilistic Classifier
%
% * *Result in book* : Figure 10.5
% * *Code in book* : Figure 10.6
% * *Output* : |eg10_2.png|
% * *Usage* : |eg10_2(), eg10_2(90, 3, 100)|
%
%% Source Code
function eg10_2(n, c, N)
    % init
    rng(0, 'v5uniform'); rng(0, 'v5normal');
    % recommended, use it in future instead of
    % rand('state', 0); randn('state', 0);
    if nargin < 3
        n = 90; c = 3; N = 100;
    end
	y = ones(n / c, 1) * (1 : c);
	y = y(:);
	x = randn(n / c, c) + repmat(linspace(-3, 3, c), n / c, 1);
	x = x(:);
	hh = 2 * 1 ^ 2; l = 0.1;
	X = linspace(-5, 5, N )';
	x2 = x .^ 2;
	X2 = X .^ 2;
	k = exp(-(repmat(x2, 1, n) + repmat(x2', n, 1) - 2 * (x * x')) / hh);
	K = exp(-(repmat(X2, 1, n) + repmat(x2', N, 1) - 2 * (X * x')) / hh);
	Kt = zeros(N, c);
	for yy = 1 : c
	    yk = (y == yy);
	    ky = k(:, yk);
	    ty = (ky' * ky + l * eye(sum(yk))) \ (ky' * yk);
	    Kt(:, yy) = max(0, K(:, yk) * ty);
	end

	ph = Kt ./ repmat(sum(Kt, 2), 1, c);

	figure('Name', 'Least-Squares Probabilistic Classifier Example');
    clf; hold on;
    title('Least-Squares Probabilistic Classifier Example');
    axis([-5 5 -0.3 1.8]);
    plot(X, ph(:, 1), 'm-');
    plot(X, ph(:, 2 ), 'r--');
    plot(X, ph(:, 3), 'b-.');
    plot(x(y == 1), -0.1 * ones(n / c, 1), 'mo');
    plot(x(y == 2), -0.2 * ones(n / c, 1), 'rx');
    plot(x(y == 3), -0.1 * ones(n / c, 1), 'bv');
    legend('q(y = 1|x)', 'q(y = 2|x)', 'q(y = 3|x)')
    saveas(gcf, 'eg10_2', 'png');
end