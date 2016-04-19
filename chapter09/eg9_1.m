%% Example 9.1 Ensemble Pruning
%
% * *Result in book* : Figure 9.4
% * *Code in book* : Figure 9.5
% * *Output* : |eg9_1.png|
% * *Usage* : |eg9_1(), eg9_1(50)|
%
%% Source Code
function eg9_1(n)
    % init
    rng(0);
    % recommended, use it in future instead of
    % rand('state', 0); randn('state', 0);
    if nargin < 1
        n = 50;
    end
    x = randn(n, 2);
    y = 2 *(x(:, 1) > x(:, 2)) - 1;
    X0 = linspace(-3, 3, n);
    [X(:, :, 1), X(:, :, 2)] = meshgrid(X0);

    d = ceil(2 * rand);
    [xs, xi] = sort(x(:, d));
    el = cumsum(y(xi));
    eu = cumsum(y(xi(end : -1 : 1)));
    e = eu(end - 1 : -1 : 1) - el(1 : end - 1);
    [~, ei] = max(abs(e));
    c = mean(xs(ei : ei + 1));
    s = sign(e(ei));
    Y = sign(s*(X(:, :, d) - c));

    figure('Name', 'Ensemble Pruning Example'); clf; hold on;
    title('Ensemble Pruning Example')
    axis([-3 3 -3 3]); axis square;
    colormap([1 0.7 1; 0.7 1 1]);
    contourf(X0, X0, Y);
    plot(x(y == 1, 1), x(y == 1, 2), 'bo');
    plot(x(y == -1, 1), x(y == -1, 2), 'rx');
    saveas(gcf, 'eg9_1', 'png');
end