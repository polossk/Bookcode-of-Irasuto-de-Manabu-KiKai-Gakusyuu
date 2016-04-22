%% Example 17.1 Locally Fisher Discriminant Analysis
%
% * *Result in book* : Figure 17.3
% * *Code in book* : Figure 17.4
% * *Output* : |eg17_2.png|
% * *Usage* : |eg17_2(), eg17_2(100)|
%
%% Source Code
function eg17_2(n)
    % init
    rng(0, 'v5uniform'); rng(0, 'v5normal');
    % recommended, use it in future instead of
    % rand('state', 0); randn('state', 0);
    if nargin < 1
        n = 100;
    end
    x_ = randn(n, 2);
    y = [ones(n / 2, 1); 2 * ones(n / 2, 1)];
    figure('Name', 'Locally Fisher Discriminant Analysis Example');
    
    x = x_;
    x(1 : n / 2, 1) = x(1 : n / 2, 1) - 4;
    x(n / 2 + 1 : end, 1) = x(n / 2 + 1: end, 1) + 4;
    [t, v] = lfisher_( x );
    subplot(2, 1, 1); hold on; title('Example A');
    axis([-8, 8, -6, 6]);
    plot(x(y == 1, 1), x(y == 1, 2), 'bo');
    plot(x(y == 2, 1), x(y == 2, 2), 'rx');
    plot(99 * [-t(1), t(1)], 99 * [-t(2), t(2)], 'k-');

    x = x_;
    x(1 : n / 4, 1) = x(1 : n / 4, 1) - 4;
    x(n / 4 + 1 : n / 2, 1) = x(n / 4 + 1: n / 2, 1) + 4;
    [t, v] = lfisher_( x );
    subplot(2, 1, 2); hold on; title('Example B');
    axis([-8, 8, -6, 6]);
    plot(x(y == 1, 1), x(y == 1, 2), 'bo');
    plot(x(y == 2, 1), x(y == 2, 2), 'rx');
    plot(99 * [-t(1), t(1)], 99 * [-t(2), t(2)], 'k-');

    saveas(gcf, 'eg17_2', 'png');

    function [t, v] = lfisher_( x )
        x = x - repmat(mean(x), [n, 1]);
        Sw = zeros(2, 2); Sb = zeros(2, 2);
        for j = 1:2
            p = x(y == j, :);
            p1 = sum(p);
            p2 = sum(p .^ 2, 2);
            nj = sum(y == j);
            W = exp(-(repmat(p2, 1, nj) + repmat(p2', nj, 1) - 2 * p * p'));
            G = p' * (repmat(sum(W, 2), [1, 2]) .* p) - p' * W * p;
            Sb = Sb + G / n + p' * p * (1 - nj / n) + p1' * p1 / n;
            Sw = Sw + G / nj;
        end
        [t, v] = eigs((Sb + Sb') / 2, (Sw + Sw') / 2, 1);
    end
end