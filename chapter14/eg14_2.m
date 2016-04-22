%% Example 14.2 Spectral Clustering
%
% * *Result in book* : Figure 14.5
% * *Code in book* : Figure 14.6
% * *Output* : |eg14_2.png|
% * *Usage* : |eg14_2(), eg14_2(500)|
%
%% Source Code
function eg14_2(n)
    % init
    rng(0, 'v5uniform'); rng(0, 'v5normal');
    % recommended, use it in future instead of
    % rand('state', 0); randn('state', 0);
    if nargin < 1
        n = 500;
    end
    c = 2; k = 10;
    t = randperm(n);
    a = linspace(0, 2 * pi, n / 2)';
    x = [a .* cos(a), a .* sin(a);
        (a + pi) .* cos(a), (a + pi) .* sin(a)];
    x = x + rand(n, 2);
    [z, ~] = lp_( x );

    m = z(t(1 : c), :);
    s0(1 : c, 1) = inf; s = s0;
    z2 = sum(z .^ 2, 2);

    for o = 1 : 1000
        m2 = sum(m .^ 2, 2);
        [~, y] = min(repmat(m2, 1, n) + repmat(z2', c, 1) - 2 * m * z');
        for t = 1 : c
            m(t, :) = mean(z(y == t, :));
            s(t, 1) = mean(d(y == t));
        end
        if norm(s - s0) < 0.001, break, end
        s0 = s;
    end

    figure('Name', 'Spectral Clustering Example'); clf; 
    suptitle('Spectral Clustering Example');
    
    subplot(2, 2, 1); hold on;
    setFigure('(a) Original Data \{\itx_i\}_{i=1}^n');
    axis([-10 10 -10 10]);
    plot(x(:, 1), x(:, 2), '.');

    subplot(2, 2, 2); hold on;
    setFigure('(d) Clustering Result \{\ity_i\}_{i=1}^n');
    axis([-10 10 -10 10]);
    plot(x(y == 1, 1), x(y == 1, 2), 'bo');
    plot(x(y == 2, 1), x(y == 2, 2), 'rx');

    subplot(2, 2, 3); hold on;
    text(-0.019, 0.9, '(b) After Projection \{\itz_i\}_{i=1}^n');
    axis([-0.02 0.01 -1 1]); xlabel('\itz');
    plot(-z, 0 .* z, '.');

    subplot(2, 2, 4); hold on;
    text(-0.019, 0.9, '(c) After Clustering \{\ity_i\}_{i=1}^n');
    axis([-0.02 0.01 -1 1]); xlabel('\itz');
    plot(-z(y == 1), 0 .* z(y == 1), 'bo');
    plot(-z(y == 2), 0 .* z(y == 2), 'rx');
    saveas(gcf, 'eg14_2', 'png');

    function [z, v] = lp_( x )
        x = x - repmat(mean(x), [n, 1]);
        x2 = sum(x .^ 2, 2);
        d = repmat(x2, 1, n) + repmat(x2', n, 1) - 2 * (x * x');
        [p, ~] = sort(d);
        W = sparse(d <= ones(n, 1) * p(k + 1, :));
        W = (W + W' ~= 0);
        D = diag(sum(W, 2));
        L = D - W;
        [z, v] = eigs(L, D, c - 1, 'sm');
    end

    function [] = setFigure( tag )
        text(-9.5, 9.0, tag);
        xlabel('\itx^{(1)}');
        ylabel('\itx^{(2)}');
    end
end