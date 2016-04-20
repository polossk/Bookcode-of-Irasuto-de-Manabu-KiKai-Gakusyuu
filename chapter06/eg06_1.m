%% Example 6.1 Least Huber Loss Regression & Least L1 Regression
%
% * *Result in book* : Figure 6.8(e = 1), Figure 6.3(e = 0.01)
% * *Code in book* : Figure 6.9
% * *Output* : |eg06_1_A.png, eg06_1_B.png, eg06_1_C.png|
% * *Usage* : |eg06_1(), eg06_1(10, 1000)|
%
%% Source Code
function eg06_1(n, N)
    % init
    rng(0, 'v5uniform'); rng(0, 'v5normal');
    % recommended, use it in future instead of
    % rand('state', 0); randn('state', 0);
    if nargin < 2
        n = 10; N = 1000;
    end

    % constant
    x = linspace(-3, 3, n)';
    X = linspace(-4, 4, N)';
    y = x + 0.2 * randn(n, 1);
    y(n) = -4;

    % plot preparation
    figure('Name', 'example 6-1 A'); clf; hold on;

    p(:, 1) = ones(n, 1);
    p(:, 2) = x;
    P(:, 1) = ones(N, 1);
    P(:, 2) = X;
    t0 = p \ y;

    e = 1;

    id = 1;
    for o = 1 : 1000
        r = abs(p * t0 - y);
        % Least Huber Loss
        w = ones(n, 1);
        w(r > e) = e ./ r(r > e);
        t = (p' * (repmat(w, 1, 2) .* p)) \ (p' * (w .* y));
        if norm(t - t0) < 0.001, break, end
        if (o <= 3)
            plotFigure(2, 2, id, num2str(o), X, P * t, x, y);
            id = id + 1;
        end
        t0 = t;
    end

    % plot final iteration result
    plotFigure(2, 2, id, num2str(o), X, P * t, x, y);
    saveas(gcf, 'eg06_1_A', 'png');

    % plot result
    figure('Name', 'example 6-1 B'); clf; hold on;
    axis([-4 4 -4.5 3.5]); xlabel('\itx');
    plot(X, P * t, 'g-', x, y, 'bo');
    title('example 6-1 final result');

    % save figure
    saveas(gcf, 'eg06_1_B', 'png');

    % with outlier
    e = 0.01;
    y(n) = x(n) + 0.2 * randn;
    for o = 1 : 1000
        r = abs(p * t0 - y);
        w = ones(n, 1);
        w(r > e) = e ./ r(r > e);
        t1 = (p' * (repmat(w, 1, 2) .* p)) \ (p' * (w .* y));
        if norm(t1 - t0) < 0.001, break, end
        t0 = t1;
    end
    y(n) = -4;
    for o = 1 : 1000
        r = abs(p * t0 - y);
        w = ones(n, 1);
        w(r > e) = e ./ r(r > e);
        t2 = (p' * (repmat(w, 1, 2) .* p)) \ (p' * (w .* y));
        if norm(t2 - t0) < 0.001, break, end
        t0 = t2;
    end
    F1 = P * t1;
    F2 = P * t2;
    err = max(F1-F2)
    figure('Name', 'example 6-1 C'); clf; hold on;
    axis([-4 4 -4.5 3.5]); xlabel('\itx');
    plot(X, P * t1, 'g-', X, P * t2, 'r-', x, y, 'bo');
    legend('without any outlier', 'with outliers', 'Input Data');
    title('example 6-1 Compare Least Huber with Least L1');

    % save figure
    saveas(gcf, 'eg06_1_C', 'png');

    % sub-function, plot sub-figure
    function [] = plotFigure( M, N, id, titlesuffix, x1, y1, x2, y2 )
        subplot(M, N, id);
        plot(x1, y1, 'g-', x2, y2, 'bo');
        axis([-4 4 -4.5 3.5]); xlabel('\itx');
        title(strcat('Iteration: ', titlesuffix));
    end
end