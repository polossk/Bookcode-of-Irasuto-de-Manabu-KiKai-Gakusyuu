%% Example 9.3 Adaboost
%
% * *Result in book* : Figure 9.13
% * *Code in book* : Figure 9.14
% * *Output* : |eg9_3_A.png, eg9_3_B.png|
% * *Usage* : |eg9_3(), eg9_3(50, 50)|
%
%% Source Code
function eg9_3(n, a)
    % init
    rng(0);
    % recommended, use it in future instead of
    % rand('state', 0); randn('state', 0);
    if nargin < 1
        n = 50; a = 50;
    end
    x = randn(n, 2);
    y = 2 *(x(:, 1) > x(:, 2)) - 1;
    X0 = linspace(-3, 3, n);
    [X(:, :, 1), X(:, :, 2)] = meshgrid(X0);
    b = 5000; Y = zeros(a, a);
    yy = zeros(size(y));
    w = ones(n, 1) / n;

    id = 1;
    figure('Name', 'Adaboost Example'); clf; hold on;
    setFigure('Adaboost Running');
    
    for jj = 1 : b
        wy = w .* y;
        d = ceil(2 * rand);
        [xs, xi] = sort(x(:, d));
        el = cumsum(wy(xi));
        eu = cumsum(wy(xi(end : -1 : 1)));
        e = eu(end - 1 : -1 : 1) - el(1 : end - 1);
        [~, ei] = max(abs(e));
        c = mean(xs(ei : ei + 1));
        s = sign(e(ei));
        yh = sign(s * (x(:, d) - c));
        R = w' * (1 - yh .* y) / 2;
        t = log((1 - R) / R) / 2;
        yy = yy + yh * t;
        w = exp(-yy .* y);
        w = w / sum(w);
        Y = Y + sign(s * (X(:, :, d) - c)) * t;
        if (jj == 1) || (rem(jj, 40) == 0 && jj / 40 < 6)
            plotFigure(2, 3, id, num2str(jj), X0, Y, x, y);
            id = id + 1;
        end
    end
    saveas(gcf, 'eg9_3_A', 'png');

    figure('Name', 'Adaboost Example'); clf; hold on;
    setFigure('Adaboost Final Result');
    contourf(X0, X0, sign(Y));
    plot(x(y == 1, 1), x(y == 1, 2), 'bo');
    plot(x(y == -1, 1), x(y == -1, 2), 'rx');
    saveas(gcf, 'eg9_3_B', 'png');

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