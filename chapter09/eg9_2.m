%% Example 9.2 Bagging
%
% * *Result in book* : Figure 9.8
% * *Code in book* : Figure 9.9
% * *Output* : |eg9_2_A.png, eg9_2_B.png|
% * *Usage* : |eg9_2(), eg9_2(50, 50)|
%
%% Source Code
function eg9_2(n, a)
    % init
    rng(0);
    % recommended, use it in future instead of
    % rand('state', 0); randn('state', 0);
    if nargin < 1
        n = 50; a = 50;
    end
    x = randn(n, 2);
    y = 2 *(x(:, 1) > x(:, 2)) - 1;
    X0 = linspace(-3, 3, a);
    [X(:, :, 1), X(:, :, 2)] = meshgrid(X0);

    id = 1;
    figure('Name', 'Bagging Example'); clf; hold on;
    setFigure('Bagging Running');

    b = 5000; Y = zeros(a, a);
    for jj = 1 : b
        d = ceil(2 * rand);
        r = ceil(n * rand(n, 1));
        xb = x(r, :);
        yb = y(r);
        [xs, xi] = sort(xb(:, d));
        el = cumsum(yb(xi));
        eu = cumsum(yb(xi(end : -1 : 1)));
        e = eu(end - 1 : -1 : 1) - el(1 : end - 1);
        [~, ei] = max(abs(e));
        c = mean(xs(ei : ei + 1));
        s = sign(e(ei));
        Y = Y + sign(s*(X(:, :, d) - c)) / b;
        if (jj == 1) || (rem(jj, 40) == 0 && jj / 40 < 6)
            plotFigure(2, 3, id, num2str(jj), X0, Y ./ jj .* b, x, y);
            id = id + 1;
        end
    end
    saveas(gcf, 'eg9_2_A', 'png');

    figure('Name', 'Bagging Example'); clf; hold on;
    setFigure('Bagging Final Result');
    contourf(X0, X0, sign(Y));
    plot(x(y == 1, 1), x(y == 1, 2), 'bo');
    plot(x(y == -1, 1), x(y == -1, 2), 'rx');
    saveas(gcf, 'eg9_2_B', 'png');

    % sub-function, plot sub-figure
    function [] = plotFigure( M, N, id, titlesuffix, x0, y0, x1, y1)
        subplot(M, N, id); hold on;
        contourf(x0, x0, sign(y0));
        plot(x1(y1 == 1, 1), x1(y1 == 1, 2), 'bo');
        plot(x1(y1 == -1, 1), x1(y1 == -1, 2), 'rx');
        setFigure(strcat('Iteration: ', titlesuffix));
    end

    % sub-function, figure setting
    function [] = setFigure( tag )
        title(tag);
        axis([-3 3 -3 3]); axis square;
        colormap([1 0.7 1; 0.7 1 1]);
    end
end