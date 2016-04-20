%% Example 7.1 Least Square Loss Classification
%
% * *Result in book* : Figure 7.2
% * *Code in book* : Figure 7.3
% * *Output* : |eg07_1.png|
% * *Usage* : |eg07_1(), eg07_1(200, 100)|
%
%% Source Code
function eg07_1(n, m)
    % init
    rng(0, 'v5uniform'); rng(0, 'v5normal');
    % recommended, use it in future instead of
    % rand('state', 0); randn('state', 0);
    if nargin < 2
        n = 200; m = 100;
    end

    % constant
    a = linspace(0, 4 * pi, n / 2);
    u = [a .* cos(a), (a + pi) .* cos(a)]' + 1 * rand(n, 1);
    v = [a .* sin(a), (a + pi) .* sin(a)]' + 1 * rand(n, 1);
    x = [u, v];
    y = [ones(1, n / 2), -ones(1, n / 2)]';

    x2 = sum(x .^ 2, 2);
    hh = 2 * 1 ^ 2;
    l = 0.01;
    % kernel function
    kernel = @(c1, n1, c2, c3, c4) ...
        (exp(-(repmat(c1, 1, n1) + repmat(c2', n, 1) - 2 * c3 * c4') / hh));

    k = kernel(x2, n, x2, x, x);
    t = (k ^ 2 + l * eye(n)) \ (k * y);

    X = linspace(-15, 15, m)'; X2 = X .^ 2;
    U = kernel(u .^ 2, m, X2, u, X);
    V = kernel(v .^ 2, m, X2, v, X);
    Z = sign(V' * (U .* repmat(t, 1, m)));
    figure('Name', 'example 7-1'); clf; hold on;
    title('Least Square Loss Classification');
    xlabel('\itx^{(1)}'); ylabel('\itx^{(2)}');
    axis([-15, 15, -15, 15]);
    contourf(X, X, Z);
    plot(x(y == 1, 1), x(y == 1, 2), 'bo');
    plot(x(y == -1, 1), x(y == -1, 2), 'rx');
    colormap([1, 0.7, 1; 0.7, 1, 1]);
    saveas(gcf, 'eg07_1', 'png');
end