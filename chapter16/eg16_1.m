%% Example 16.1 Laplacian Regularization Least Squares
%
% * *Result in book* : Figure 16.3
% * *Code in book* : Figure 16.4
% * *Output* : |eg16_1_A.png, eg16_1_B.png|
% * *Usage* : |eg16_1(), eg16_1(200)|
%
%% Source Code
function eg16_1(n)
    % init
    rng(0, 'v5uniform'); rng(0, 'v5normal');
    % recommended, use it in future instead of
    % rand('state', 0); randn('state', 0);
    if nargin < 1
        n = 200;
    end
    a = linspace(0, pi, n / 2);
    u = -10 * [cos(a) + 0.5, cos(a) - 0.5]' + randn(n, 1);
    v = 10 * [sin(a), -sin(a)]' + randn(n, 1);
    x = [u v]; y = zeros(n, 1); y(1) = 1; y(n) = -1;
    x2 = sum(x .^ 2, 2); hh = 2 * 1 ^ 2;
    m = 100; X = linspace(-20, 20, m)'; X2 = X .^ 2;
    U = exp(-(repmat(u .^ 2, 1, m) + repmat(X2', n, 1) - 2 * u * X') / hh);
    V = exp(-(repmat(v .^ 2, 1, m) + repmat(X2', n, 1) - 2 * v * X') / hh);

    figure('Name', 'Laplacian Regularization Least Squares'); clf;
    k = exp(-(repmat(x2, 1, n) + repmat(x2', n, 1) - 2 * (x * x')) / hh);
    w = k;
    t = (k ^ 2 + 1 * eye(n) + 10 * k * (diag(sum(w)) - w) * k) \ (k * y);
    hold on; axis([-20 20 -20 20]);
    title('Laplacian Regularization Least Squares');
    colormap([1 0.7 1; 0.7 1 1]);
    contourf(X, X, sign(V' * (U .* repmat(t, 1, m))));
    plot(x(y == 1, 1), x(y == 1, 2 ), 'bo');
    plot(x(y == -1, 1), x(y == -1, 2), 'rx');
    plot(x(y == 0, 1), x(y == 0, 2), 'k.');
    saveas(gcf, 'eg16_1_A', 'png');

    figure('Name', 'Least Squares'); clf;
    [XX, YY] = meshgrid(X, X);
    DDP = (XX - x(1, 1)) .^ 2 + (YY - x(1, 2)) .^ 2;
    DDN = (XX - x(n, 1)) .^ 2 + (YY - x(n, 2)) .^ 2;
    DD = sign(DDN - DDP);
    hold on; axis([-20 20 -20 20]);
    title('Least Squares');
    colormap([1 0.7 1; 0.7 1 1]);
    contourf(X, X, DD);
    plot(x(y == 1, 1), x(y == 1, 2 ), 'bo');
    plot(x(y == -1, 1), x(y == -1, 2), 'rx');
    plot(x(y == 0, 1), x(y == 0, 2), 'k.');
    saveas(gcf, 'eg16_1_B', 'png');
end